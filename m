From: Chee Yong TAN <chee_yong_tan@hotmail.com>
Subject: Re: Sending back out A TCP Packet from netfilter
Date: Tue, 24 Feb 2004 15:00:19 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <403AF683.2060905@hotmail.com>
References: <Pine.LNX.4.44.0402231518470.1686-100000@filer.marasystems.com> <403AB462.6080404@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <403AB462.6080404@hotmail.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Additional information regarding unable to sending back out thru lo interface

my module hooks on 2 netfilter hooks NF_IP_LOCAL_IN and NF_IP_POST_ROUTING

I did see the reply packet going out via the POST_ROUTING hook and coming back 
via the LOCAL_IN hook

Note: There is extensive logging in my module looking at the network headers.
The header information do not seems to have any problem.

POST_ROUTING - orginal packet
LOCAL_IN - orginal packet
POST_ROUTING - reply packet
LOCAL_IN - reply packet

both tcpdump and my application failed to receive the changed packet.

i even tried flushing off my iptables to get rid of all the rules and set back 
the policy to ACCEPT for all chains

The application running from another subnetwork connecting to my machine works 
perfectly fine (with iptables firewalling rules turned on)...
