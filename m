From: varun <varun@rocsys.com>
Subject: iptables doubt
Date: Wed, 12 Apr 2006 19:24:47 +0530
Message-ID: <443D06A7.1060504@rocsys.com>
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

             Iam new to netfilters and iam trying to play around to 
understand a few things. By default when no policies are specified then 
it allows all traffic to go out and in to the n/w. I want to change this 
to default as deny.
             That is when there is no policy all should be default deny.

           So in order to achieve that i tried to change the  code a little.
            In the file iptable_filter.c there is a variable called 
static int forward = NF_ACCEPT
             I changed this to NF_DROP and when i compiled and used it 
sure i was not able to send any or recv any packets
             but even after i give a policy like iptables -t filter -A 
INPUT -j ACCEPT
             Nothing changes. So achieve what i want what should i do? 
And where do i change?

             Another thing is that in normally when i put a policy like 
iptables -t filter -A OUTPUT -j REJECT
              Even my own self IP doesnt ping? Why should this happen?
               Isint it ok to ping local ip and loopback ip?
                If i want such implementation where i should be able to 
ping to self and local but not any other ip?
                Is it possible?
                I dont want to add policies rather is it possible just 
by changing the iptables kernel code?

                Please help me on this?

Varun
