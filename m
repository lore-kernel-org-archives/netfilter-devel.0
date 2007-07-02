From: Lionel Flahaut <lionelflahaut@yahoo.fr>
Subject: Question about libnetfilter_queue
Date: Mon, 2 Jul 2007 12:10:52 +0200
Message-ID: <8650D698-CBCC-4914-B313-C57601676FED@yahoo.fr>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Dears,

I'm working on a content filtering application for http in user space  
using the libnetfiter_queue.

I have to handle tcp packet on port 80, check their content until a  
complete http response has been received before sending the original  
or  modified packets.

I need to send modified packet when the content is not appropriate  
for children and need to be changed to the block page.

Until now, I successfully intercept the first packet of http  
response, mangle it to the block and set a verdict NF_ACCEPT to the  
modified packet.

Now, I want to get all the packet of a http response not only the  
first before mangling it.

I think about the NF_STOLEN verdict to keep the packets in userspace  
and set a verdict later but I didn't find a way to reinject stolen  
packet in netfilter.

Is using NF_STOLEN verdict the good way for doing what I need?

If so, how do I reinject the packet ?

Thank you for your answer.

Lionel
