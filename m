From: "Martin Shaw" <MartinS@pivetal.com>
Subject: nfnetlink_queue/nfnetlink_log performance
Date: Tue, 23 May 2006 22:09:44 +0100
Message-ID: <F765B0CA752F3448B2698F0FB7DCB39805BDC4@sv-janus.pivetal.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
To: <netfilter-devel@lists.netfilter.org>
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

I'm currently testing these nfnetlink extensions in terms of forwarding =
packets from large numbers of rtp streams.

My testing so far has been based on the test apps in the respective =
/utils folders.

I have cut down the processing to a fairly minimal extract id then =
reinject (for the queue app) but even so I am experiencing problems with =
higher packet rates (>1000/s). Under these conditions, the cpu =
utilisation is extremely high. The breaking point is always a -1 return =
from the recv() call made on the fd returned for the netlink socket.

The benchmark is against a libpcap type setup, where this volume and =
higher is attainable. There are many other mechanisms of the =
kernel/netfilter that we wish to utilise so that's why just using =
libpcap isn't really an option.

Anybody done some tests with these extensions under high load? What I'm =
really interested in is any indication of which mechanism (queue or =
ulog) is more suited to high throughput? Do these mechanisms scale well? =
I've tweaked a lot with the libnfnetlink source and with the kernel =
modules (increasing max q length etc) but nothing seems to shift the =
breaking point considerably.

Any comments/ideas would be most appreciated.


Thanks.

Martin.
