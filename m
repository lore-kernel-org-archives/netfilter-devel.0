From: Jim Mar <jmar@metavize.com>
Subject: Bridging and IPT Queueing
Date: Thu, 08 Jul 2004 22:05:23 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40EE2793.7060205@metavize.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I've been looking at IPT Queueing in a bridging environment on
a 2.6 kernel and noticed that the indev associated with the
queued packet is the bridge device, eg. br0, instead of the
physical interface. While this is true, it would be nice to know
the physical indev of the packet. Is there a way of finding it?
I tried looking at the HW address, but that seems broken.
Thanks,

Jim
