From: "Gaurav Aggarwal" <grv.aggarwal@gmail.com>
Subject: Packet drop during re-routing via netfilters
Date: Thu, 13 Sep 2007 18:54:15 +0530
Message-ID: <1a41e0840709130624q436c5d03mb34ecdd5b91b60a3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----=_Part_18733_19239382.1189689855341"
Cc: "Gaurav Aggarwal" <grv.aggarwal@gmail.com>
To: kernelnewbies@nl.linux.org, netfilter-devel@lists.netfilter.org
Return-path: <kernelnewbies-bounce@nl.linux.org>
Sender: kernelnewbies-bounce@nl.linux.org
Errors-to: kernelnewbies-bounce@nl.linux.org
List-help: <mailto:ecartis@nl.linux.org?Subject=help>
List-unsubscribe: <mailto:kernelnewbies-request@nl.linux.org?Subject=unsubscribe>
List-software: Ecartis version 1.0.0
List-subscribe: <mailto:kernelnewbies-request@nl.linux.org?Subject=subscribe>
List-owner: <mailto:ecartis-owner@nl.linux.org>
List-post: <mailto:kernelnewbies@nl.linux.org>
List-archive: <http://mail.nl.linux.org/kernelnewbies/>
List-Id: netfilter-devel.vger.kernel.org

------=_Part_18733_19239382.1189689855341
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

I'm using ip_tables and ip_queue modules to trap the packets from IP stack
to a userspace VPN product, using nothing but standard kernel modules (and
my own VPN proxy app). The packets flowing into or out of the machine get
diverted to a userspace application (actually a VPN client), where src/dest
addresses are modified if needed, and then injected back into the local IP
stack.

For example, an outgoing packet (that has a foreign dest addr) is overridden
with a local dest address, hoping it would end up at the local VPN listener.


Under kernel 2.4(checked on 2.4.20) this works fine.
In 2.6 it doesn't.

To me its seems that while traversing packets through Netfilter, changing
dest address from a foreign to a local address causes the packet to drop
(and show up at ip_rt_bug(), along a syslog entry in kernel 2.6..

* Details:
An outgoing packet (has a non-local dest addr) is queued and recognized at
the ip_queue userspace app. Its dest addr+port are set to that of the local
machine (to get to my userspace VPN app).
The modified packet is marked NF_ACCEPT and sent back into the kernel, but
ends up at the ip_rt_bug function (with a syslog entry).

* Assumed bug analysis:
Due to the destination address change, the packet needed to go through
routing once again, since it's no longer an outgoing packet.
I would have expected the routing function to realize it needs to
re-evaluate the route, and set the *okfn to dst->input instead of ip_rt_bug.

* Kernel version where problem found:
2.6.14 compiled locally with no modifications.

Please advise/suggest me what alternative I have now.

A similar problem has been reported a while back but never replied (
http://groups-beta.google.com/group/linux.kernel/msg/455c04e17e354d04?dmode=source&hl=en
)

-- 
Regards,
Gaurav Aggarwal

------=_Part_18733_19239382.1189689855341
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,<br><br>I&#39;m using ip_tables and ip_queue modules to trap the packets from IP stack to a userspace
VPN product, using nothing but standard kernel modules (and my own VPN
proxy app). The packets flowing into or out of the machine get diverted to a
userspace application (actually a VPN client), where src/dest addresses are modified if needed, and then injected
back into the local IP stack. <br>

<br>

For example, an outgoing packet (that has a foreign dest addr) is
overridden with a local dest address, hoping it would end up at the
local VPN listener. <br>

<br>

Under kernel 2.4(checked on 2.4.20) this works fine.<br>

In 2.6 it doesn&#39;t.<br>

<br>To me its seems that while traversing packets through Netfilter, changing dest address from
a foreign to a local address causes the packet to drop (and show up at
ip_rt_bug(), along a syslog entry in kernel 2.6..<br>
<br>
* Details:<br>
An outgoing packet (has a non-local dest addr) is queued and recognized
at the ip_queue userspace app. Its dest addr+port are set to that of
the local machine (to get to my userspace VPN app).<br>
The modified packet is marked NF_ACCEPT and sent back into the kernel,
but ends up at the ip_rt_bug function (with a syslog entry).<br>
<br>
* Assumed bug analysis:<br>
Due to the destination address change, the packet needed to go through
routing once again, since it&#39;s no longer an outgoing packet.<br>I would have expected the routing function to realize it needs to
re-evaluate the route, and set the *okfn to dst-&gt;input instead of ip_rt_bug.<br>
<br>
* Kernel version where problem found:<br>
2.6.14 compiled locally with no modifications.<br>
<br>
Please advise/suggest me what alternative I have now.<br>
<br>
A similar problem has been reported a while back but never replied (<a href="http://groups-beta.google.com/group/linux.kernel/msg/455c04e17e354d04?dmode=source&amp;hl=en">http://groups-beta.google.com/group/linux.kernel/msg/455c04e17e354d04?dmode=source&amp;hl=en
</a>)<br>
<br>
-- <br>Regards,<br>Gaurav Aggarwal<br><br>

------=_Part_18733_19239382.1189689855341--

--
To unsubscribe from this list: send an email with
"unsubscribe kernelnewbies" to ecartis@nl.linux.org
Please read the FAQ at http://kernelnewbies.org/FAQ
