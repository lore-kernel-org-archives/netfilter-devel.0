From: Menno Smits <menno@netbox.biz>
Subject: PPTP connection tracking and Poptop on same box
Date: Tue, 02 Sep 2003 15:36:14 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F542C4E.1000307@netbox.biz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

I'm experiencing some frustrating problems using PPTP connection
tracking/NAT with Poptop on the same box.

I'm using kernel 2.4.21 with the latest PPTP (and related) POM patches
from CVS. I'm using Poptop v1.1.4.

Without ip_nat_pptp and friends loaded connections to Poptop work
flawlessly.

When ip_nat_pptp etc is loaded connection tracking and NAT _through_
the box to external servers works great.

However, when the PPTP NAT+conntrack modules are loaded, connections
to Poptop running on the Linux box are highly unreliable.  Connections
to Poptop are difficult to establish and generally take several
attempts before they work.  Sometimes you get lucky and the connection
works first go. Other times it can take 10s of attempts. Once a
connection is established it seems to function and remain that way.

There seems to be two types of errors I get from Poptop and pppd when
a connection attempt fails. They seem to be fairly interchangable.

The first is the "Operation not permitted" error:

Sep  2 12:25:47 host pptpd[19967]: CTRL: Client 10.233.0.1 control 
connection started
Sep  2 12:25:47 host pptpd[19967]: CTRL: Starting call (launching pppd, 
opening GRE)
Sep  2 12:25:47 host pppd[19968]: pppd 2.4.2b3 started by root, uid 0
Sep  2 12:25:47 host pppd[19968]: Using interface ppp1
Sep  2 12:25:47 host pppd[19968]: Connect: ppp1 <--> /dev/pts/2
Sep  2 12:25:47 host pptpd[19967]: GRE: Bad checksum from pppd.
Sep  2 12:25:47 host pptpd[19967]: GRE: xmit failed from decaps_hdlc: 
Operation not permitted
Sep  2 12:25:47 host pptpd[19967]: CTRL: PTY read or GRE write failed 
(pty,gre)=(5,6)
Sep  2 12:25:47 host pptpd[19967]: CTRL: Client 10.233.0.1 control 
connection finished
Sep  2 12:25:47 host pppd[19968]: Terminating on signal 2.
Sep  2 12:25:47 host pppd[19968]: Modem hangup
Sep  2 12:25:47 host pppd[19968]: Connection terminated.
Sep  2 12:25:47 host pppd[19968]: Exit.

The second is the "LCP: timeout sending Config-Requests" error:

Aug 26 11:07:38 host pptpd[16915]: CTRL: Client 10.233.0.8 control 
connection started
Aug 26 11:07:38 host pptpd[16915]: CTRL: Starting call (launching pppd, 
opening GRE)
Aug 26 11:07:38 host pppd[16916]: pppd 2.4.2b3 started by root, uid 0
Aug 26 11:07:38 host pppd[16916]: Using interface ppp1
Aug 26 11:07:38 host pppd[16916]: Connect: ppp1 <--> /dev/pts/1
Aug 26 11:07:38 host pptpd[16915]: GRE: Bad checksum from pppd.
Aug 26 11:08:08 host pppd[16916]: LCP: timeout sending Config-Requests
Aug 26 11:08:08 host pppd[16916]: Connection terminated.
Aug 26 11:08:08 host pppd[16916]: Exit.
Aug 26 11:08:08 host pptpd[16915]: GRE: 
read(fd=5,buffer=804d960,len=8196) from PTY failed: status = -1 error = 
Input/output error
Aug 26 11:08:08 host pptpd[16915]: CTRL: PTY read or GRE write failed 
(pty,gre)=(5,6)
Aug 26 11:08:08 host pptpd[16915]: CTRL: Client 10.233.0.8 control 
connection finished

Some other possibly relevant details:

The MTU and MRU on PPTP PPP intefaces is set quite low (750) to avoid
"out of order packet" issues commonly experienced with Poptop.

TCPMSS is set to 706 for all TCP traffic going through PPTP interfaces
for similar reasons. This is done with the following rules:

TCPMSS     tcp  --  ppp+   *       0.0.0.0/0            0.0.0.0/0
tcp flags:0x06/0x02 TCPMSS set 706
TCPMSS     tcp  --  *      ppp+    0.0.0.0/0            0.0.0.0/0 
   tcp flags:0x06/0x02 TCPMSS set 706

During my testing generally only _one_ host is used for anything to do
with PPTP (either PPTP NAT thru the firewall or PPTP connection to the
firewall). I would of course like multiple clients working both thru
and connecting to the firewall box.

I've primarily been testing with WinXP and Win2k clients.

I've tested this with a totally clear firewall (just ACCEPT policies
on the default chains) with the PPTP conntrack modules loaded and the
problem still occurs.

A possibly useful observation:
I've found that when I'm having troubles connecting from a Windows
client to Poptop, connecting to a Windows 2000 PPTP server,
disconnecting, and then trying Poptop again causes things to work in
straight away or with 1 retry. I suspect the whole problem here is
timing related (hence the intermittent nature).  I'm guessing that
once the Windows client has successfully connected somewhere the
timing of packet transmissions during future connections changes in
our favour wrt the Linux config. I know this sounds "out there" but
this is repeatable behaviour.

I've googled around extensively and hunted through the netfilter
mailing list archives and have found some posts describing similar
problems but no conclusive answers. I've tried with and without
LOCAL_NAT compiled in.

Is there a way to get PPTP NAT and Poptop to co-exist happily on the
same box?

I would really like to get this working and am happy to try patches,
test various scenarios, provide packet dumps or whatever is required.

Any help or pointers would be greatly appreciated.

The PPTP NAT modules seem really close to being fully functional. It
would be fantastic to iron out the last remaining issues.

Thanks,
Menno
