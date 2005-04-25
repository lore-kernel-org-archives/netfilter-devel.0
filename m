From: "Yair Itzhaki" <Yair@arx.com>
Subject: RE: Re-routing packets via netfilter (ip_rt_bug)
Date: Mon, 25 Apr 2005 18:51:25 +0200
Message-ID: <4151C0F9B9C25C47B3328922A6297A3286CFA5@post.arx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: <linux-kernel@vger.kernel.org>,
	"Netfilter Development Mailinglist"
	<netfilter-devel@lists.netfilter.org>
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S262683AbVDYQAK@vger.kernel.org>
Content-class: urn:content-classes:message
To: "Patrick McHardy" <kaber@trash.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

No, this does not help.
The failure is now inside "ip_route_output_slow", since the reversed address packet has the source address of the remote machine, and the call to "ip_dev_find" fails to find a device with matching address.

In 2.4 the okfn pointer used to point to "ip_queue_xmit2" which evaluated the new route from scratch. 
It was passed in as the completion function when calling the NF_HOOK chain.
In 2.6 this function is gone (replaced with a reference to "dst_output).

Was removing it a mistake?


-----Original Message-----
From: Patrick McHardy [mailto:kaber@trash.net]
Sent: Monday, April 25, 2005 11:07
To: Yair Itzhaki
Cc: linux-kernel@vger.kernel.org; Netfilter Development Mailinglist
Subject: Re: Re-routing packets via netfilter (ip_rt_bug)


Yair Itzhaki wrote:
> While traversing packets through Netfilter, changing dest address from a foreign to a local address causes the packet to drop (and show up at ip_rt_bug(), along a syslog entry).

Does this patch fix your problem?
