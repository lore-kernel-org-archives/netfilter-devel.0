From: Patrick Schaaf <bof@bof.de>
Subject: Re: "Proper" way to transparent proxy?
Date: Wed, 9 Oct 2002 22:40:18 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021009204018.GA15171@oknodo.bof.de>
References: <3DA48D59.7060109@secureinteriors.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Kevin White <kwhite@secureinteriors.com>
Content-Disposition: inline
In-Reply-To: <3DA48D59.7060109@secureinteriors.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> I need to find the address and port the outgoing connecion was 
> originally heading to.

Use standard iptables, with a commandline like this:

	iptables -t nat -p tcp --dport 80 -j REDIRECT --to-port 1234

> I expect that I'll be able to reuse most of my code: just the lookup 
> part needs to change.

Once upon at time, in Linux 2.0.x, with libc5, you had getsockname()
return TheRightThing - in this particular situation. This is no longer
the case. Nowadays, with iptables and a rule like the one above, you
call getsockopt(), querying for SO_ORIGINAL_DST.

google tells me, giving it that hint, that no better documentation
than some ooooold mail threads exists on SO_ORIGINAL_DST. My bad.
I hate it when mailing list traffic by me is first hit :)

For the benefit of the eternal (hope hope hope) google, I am using
the exact code below, compiled like this:

	gcc -c preload_getsockname.c
	ld -o preload_getsockname.so -shared preload_getsockname.o -ldl

as an LD_PRELOAD file for a very ancient squid binary. In production
on some handful on boxes. You probably only need the 'getsockopt' line.

It works(tm).

best regards
  Patrick

#include <sys/socket.h>
#include <dlfcn.h>

#ifndef SO_ORIGINAL_DST
#include <linux/netfilter_ipv4.h>
#ifndef SO_ORIGINAL_DST
#error no SO_ORIGINAL_DST defined
#endif
#endif

int getsockname(int fd, struct sockaddr *sa, int *salen)
{
        static int (*libc_getsockname)(int, struct sockaddr *, int *);
        int ret;

        if (!libc_getsockname) {
                libc_getsockname = (int (*)(int, struct sockaddr *, int
*))
                        dlsym(RTLD_NEXT, "getsockname");
        }
        ret = getsockopt(fd, SOL_IP, SO_ORIGINAL_DST, sa, salen);
        if (ret < 0 && libc_getsockname)
                ret = libc_getsockname(fd, sa, salen);
        return ret;
}
