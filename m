From: "peter smith" <smith-peter@comcast.net>
Subject: real time stateful filtering question
Date: Mon, 15 Mar 2004 10:54:00 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <NEBBJFIAIKIHKGJDONCDAEMMCCAA.smith-peter@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello,

Sorry if this topic has come up before, but I was unable to find any past
posting on the subject:

If I wish to monitor using netfilter a link that has applications talking on
it that use ephemeral ports (like, for instance, FTP or H323), is there a
way to install filters fast enough /syncronously enough to guarantee that
you won't miss packets that you have already received? For instance, say
that you have some number of packets in your rx ring buffer waiting to be
processed. The first one is processed, and matches some filter you have set.
That packet is queued for delivery to userland.

That packet also has a FTP PORT command inside it's payload that specifies
the new data channel that the two hosts will use to transfer data. (where
channel == the src/dst ip and src/dst ports)

Unfortunately, packets sent on the data channel are also in your receive
buffer, and get processed by netfilter *before* the "PORT COMMAND" packet
gets processed by the userland monitor, or before the monitor can
sucessfully re-program the netfilter filter list. So they are dropped,
silently.

I have exaggerated this example a bit for clarity, but I believe the race
condition exists, particularly wrt the filter reprogramming.

Is this truly a problem? Have others found a way around it? It appears that
for a stateful filtering application, a user must build a faster mechanism
for programming the filters?

Any comments greatly appreciated.

Thanks,
Peter
