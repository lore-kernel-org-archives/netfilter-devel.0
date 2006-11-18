From: "Laurence J. Lane" <ljlane@debian.org>
Subject: Re: iptables 1.3.6 not using /etc/networks
Date: Sat, 18 Nov 2006 17:09:27 -0500
Message-ID: <cd6061db0611181409i27ef1f68l49517bf56c45128b@mail.gmail.com>
References: <cd6061db0611111725q2822d96cg2272b44dc3e85d0b@mail.gmail.com>
	<cd6061db0611111835u7d6ea889g56822e458e3e12f2@mail.gmail.com>
	<20061112173312.GA2593@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Phil Oester" <kernel@linuxace.com>
In-Reply-To: <20061112173312.GA2593@linuxace.com>
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On 11/12/06, Phil Oester <kernel@linuxace.com> wrote:

> Not sure offhand how we can satisfy both cases here, but I'd posit
> that more people use x.x.x/24 than use foonet/x notation.

I have another bug report saying it breaks stuff from /etc/hosts too.

How about something like this? I assume valid IP characters are in the
range of 0-9 and a dot. This will skip pad_cidr() if any characters
outside of that range are encountered. Plain bad IP addresses are
apparently validated elsewhere. Of course, I could be wrong about all
of this.

--- iptables.c.ORIG     2006-11-18 16:40:30.902915398 -0500
+++ iptables.c  2006-11-18 16:38:31.549789934 -0500
@@ -696,13 +696,15 @@
        char buf[256];
        char *p;
        int i, j, k, n;
+       char *vipchars = "0123456789.\0";

        strncpy(buf, name, sizeof(buf) - 1);
        buf[sizeof(buf) - 1] = '\0';
        if ((p = strrchr(buf, '/')) != NULL) {
                *p = '\0';
                addrp = parse_mask(p + 1);
-               if (strrchr(p + 1, '.') == NULL)
+               if (strrchr(p + 1, '.') == NULL
+                 && strspn(buf,vipchars) == strlen(buf))
                        pad_cidr(buf);
        } else
                addrp = parse_mask(NULL);


Simple tests:

  # echo "foonet0 3.2.1.0" > /etc/networks
  # for i in 8 16 24 32; do iptables -v -A INPUT -s foonet0/$i -j ACCEPT; done
  ACCEPT  0 opt -- in * out *  3.2.1.0  -> 0.0.0.0/0
  ACCEPT  0 opt -- in * out *  3.2.1.0/24  -> 0.0.0.0/0
  ACCEPT  0 opt -- in * out *  3.2.0.0/16  -> 0.0.0.0/0
  ACCEPT  0 opt -- in * out *  3.0.0.0/8  -> 0.0.0.0/0

  # echo 1.2.3.4 foo.bar.baz.quuz >> /etc/hosts
  # for i in 8 16 24 32; do iptables -v -A INPUT -s
foo.bar.baz.quuz/$i -j ACCEPT; done
  ACCEPT  0 opt -- in * out *  1.0.0.0/8  -> 0.0.0.0/0
  ACCEPT  0 opt -- in * out *  1.2.0.0/16  -> 0.0.0.0/0
  ACCEPT  0 opt -- in * out *  1.2.3.0/24  -> 0.0.0.0/0
  ACCEPT  0 opt -- in * out *  1.2.3.4  -> 0.0.0.0/0
