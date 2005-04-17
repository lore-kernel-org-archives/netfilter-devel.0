From: Juha Heljoranta <juha.heljoranta@evtek.fi>
Subject: iptables module linking issue
Date: Sun, 17 Apr 2005 15:07:45 +0300
Message-ID: <42625191.8060805@evtek.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
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

Hi,

I had a trouble while trying to get iptables to load my extension. Here
is what I mean:


$ /usr/local/sbin/iptables -A INPUT -m vmexec --vmexec-file \
/usr/bin/wget -j ACCEPT
iptables v1.2.11: Couldn't load match
`vmexec':/usr/local/lib/iptables/libipt_vmexec.so: undefined symbol: stat

Try `iptables -h' or 'iptables --help' for more information.
$ # libc is missing, fix it with -lc
$ ld -shared  -o extensions/libipt_vmexec.so \
extensions/libipt_vmexec_sh.o -lc
$ cp extensions/libipt_vmexec.so \
/usr/local/lib/iptables/libipt_vmexec.so
$ # now it works
$ /usr/local/sbin/iptables -A INPUT -m vmexec --vmexec-file \
/usr/bin/wget -j ACCEPT


I tried to compile iptables with NO_SHARED_LIBS=1 resulting lot of
compile errors.

I also tried to add #include <sys/stat.h> into iptables.c with no effect.

What would be the correct way to get some symbol properly linked into
iptables module?

Regards,
Juha Heljoranta
