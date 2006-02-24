From: Carlos Munoz <carlos@kenati.com>
Subject: Connection tracking has the same source on original and reply
Date: Thu, 23 Feb 2006 17:08:27 -0800
Message-ID: <43FE5C8B.60402@kenati.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hi all,

I'm debugging a SIP ALG I wrote and find that occasionally connection 
tracking has the same ip address in the original direction as in the 
reply direction. I can only assume this is caused by setting the 
expected related connection wrong. However, I've verified that the right 
tuples are set up in the expected related connection request. 
Interesting enough is that this only happens when registering the 
expected related connection when receiving a reply.

udp      17 14 src=192.168.16.200 dst=192.168.16.100 sport=10010 
dport=41000 [UNREPLIED] src=192.168.16.200 dst=192.168.16.100 
sport=41000 dport=10010 use=1

Has anyone seen this before ?

Thanks,


Carlos Munoz
