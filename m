From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: real time stateful filtering question
Date: Wed, 17 Mar 2004 11:10:33 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403171102570.6035-100000@filer.marasystems.com>
References: <1079509777.8006.182822495@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: peter smith <smith-peter@comcast.net>,
   Netfilter Community <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Saber zrelli <saber_z@fastmail.fm>
In-Reply-To: <1079509777.8006.182822495@webmail.messagingengine.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 17 Mar 2004, Saber zrelli wrote:

> if there is a kernel module that does the filtering , why does race
> still exist

Because if the application does not wait for a response to their control 
message before starting to use the "related" connection there is no 
guarantee the control message is seen before traffic on the related 
connection. This is due to how IP operates, not an artefact of netfilter.

Filtering in userspace only widens this window considerably from tiny to 
significant, but there is numerous other cases where this window gets 
opened

  * SMP, allowing processing of multiple packets in parallell by the 
kernel.
  * Control message lost in transit, before reaching the firewall.
  * Control message delayed in transit, causing the "related" packets to 
reach the firewall before the control message.


In the example of FTP this window does not at all exists as FTP always 
waits for the response to the control message before any "related" 
traffic. Here it does not matter at all if you run the tracking in kernel 
or userspace, in both cases there won't be any related traffic until you 
have processed and forwarded the control message so there is no 
possibility there is related traffic queued at the same time or arriving 
while you are processing the control message.

Regards
Henrik
