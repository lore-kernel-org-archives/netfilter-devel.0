From: Oumer Teyeb <oumer@cpk.auc.dk>
Subject: Packet Headers
Date: Tue, 25 Feb 2003 10:31:33 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E5B37F5.5040400@cpk.auc.dk>
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

Hi all,

I was trying to get used to libipq and netfilter for the last two couple 
of days, and I am quite amazed how easy it is to filter packets from 
userspace using these tools. I have one question though which I couldn't 
manage to find the answer to in the documentations at netfilter.org, and 
I think maybe because it is trivial. When I get a packet through the 
libipq if I use only IPQ_COPY_META as the argument in the ipq_set_mode 
function, I will get only the headers. If I use IPQ_COPY_PACKET then i 
will get both packet data and headers. The problem I have is what 
"headers" are we talking about "IP headers" (that is TCP header + IP 
header ) or a packet header at the physical level where there is also 
the header of the MAC and PHY layer appended in front of the TCP and IP 
headers?

Regards,
Oumer


 
