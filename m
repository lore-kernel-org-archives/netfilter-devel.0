From: "Salim" <salim.si@askey.com.tw>
Subject: Re: ip_queue module issue
Date: Wed, 4 Jan 2006 10:14:38 +0800
Message-ID: <002c01c610d4$a04e3930$455f030a@askeyrd3>
References: <002301c61010$3fa46f60$455f030a@askeyrd3>
	<43BA74FD.9030205@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: lartc@mailman.ds9a.nl,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <lartc-bounces@mailman.ds9a.nl>
To: "Patrick McHardy" <kaber@trash.net>
List-Unsubscribe: <http://mailman.ds9a.nl/cgi-bin/mailman/listinfo/lartc>,
	<mailto:lartc-request@mailman.ds9a.nl?subject=unsubscribe>
List-Archive: <http://mailman.ds9a.nl/pipermail/lartc>
List-Post: <mailto:lartc@mailman.ds9a.nl>
List-Help: <mailto:lartc-request@mailman.ds9a.nl?subject=help>
List-Subscribe: <http://mailman.ds9a.nl/cgi-bin/mailman/listinfo/lartc>,
	<mailto:lartc-request@mailman.ds9a.nl?subject=subscribe>
Sender: lartc-bounces@mailman.ds9a.nl
Errors-To: lartc-bounces@mailman.ds9a.nl
List-Id: netfilter-devel.vger.kernel.org

it does work when iptables as a whole is built as a module.

----- Original Message -----
From: "Patrick McHardy" <kaber@trash.net>
To: "Salim" <salim.si@askey.com.tw>
Cc: <lartc@mailman.ds9a.nl>; "Netfilter Development Mailinglist"
<netfilter-devel@lists.netfilter.org>
Sent: Tuesday, January 03, 2006 8:58 PM
Subject: Re: [LARTC] ip_queue module issue


> Salim wrote:
> > Hi All,
> >    I am adding ip_queue module for snort inline IDS.
> >
> > I am using snort2.4.0
> > And iptables-1.3.4.
> >
> > Userspace Queuing(queue target) is enabled. It is built-in and not built
as
> > a module.
> > The output of /proc/net/ip_queue is shown below:
> >
> > cat /proc/net/ip_queue>
> > Peer PID          : 0
> > Copy mode         : 0
> > Copy range        : 0
> > Queue length      : 0
> > Queue max. length : 1024
> >
> >
> > IPTABLES 1.3.4 is being used and it is built with install-devel option
> > And libipq.a is seen in /lib directory.
> >
> > SNORT is also built in with following options:
> > ./configure --prefix=/usr/local/snort \
> > --with-libpcap-includes=/usr/local/snort-lib/include \
> > --with-libpcap-libraries=/usr/local/snort-lib/lib \
> > --with-libpcre-includes=/usr/local/snort-lib/include \
> > --with-libpcre-libraries=/usr/local/snort-lib/lib \
> > --with-libnet-includes=/usr/local/snort-lib/include \
> > --with-libnet-libraries=/usr/local/snort-lib/lib \
> > --with-libipq-includes=/usr/local/iptables/include \
> > --with-libipq-libraries=/usr/local/iptables/lib \
> > --enable-inline
> >
> > cat /proc/net/netlink>
> > sk       Eth Pid    Groups   Rmem     Wmem     Dump     Locks
> > c11c8040 0   0      00000000 0        0        00000000 2
> > c7ec0140 3   0      00000000 0        0        00000000 7
> > c11c8780 4   0      00000000 0        0        00000000 2
> > c7e74c40 5   0      00000000 0        0        00000000 2
> >
> > Starting SNORT now:
> > /usr/local/snort/bin/snort -Q -N -l /var/log/snortlog -t
> > /var/log/snortlog -s -D>
> > Initializing Inline mode
> > Reading from iptables
> > InitInline: : Failed to send netlink message: Connection refused
> > Starting snortd: FAILED
> >
> > cat /proc/net/netlink>
> > sk       Eth Pid    Groups   Rmem     Wmem     Dump     Locks
> > c11c8040 0   0      00000000 0        0        00000000 2
> > c7ec0140 3   0      00000000 0        0        00000000 8  >>>Locks
> > increasing
> > c11c8780 4   0      00000000 0        0        00000000 2
> > c7e74c40 5   0      00000000 0        0        00000000 2
> >
> > Can anybody please point me as to what could be the issue. As it is the
> > ip_queue
> > Is built in kernel and it is running as can be seen from cat
> > /proc/net/ip_queue
>
> Does it work if you build it as a module? If not please send the output
> of strace -s 1000 -f snort ...
