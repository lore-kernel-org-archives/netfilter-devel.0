From: Emmanuel Fleury <fleury@cs.auc.dk>
Subject: Re: Security flaw in Stateful filtering ??????
Date: Thu, 06 Jun 2002 20:52:13 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <3CFFAF5D.4010103@cs.auc.dk>
References: <Pine.LNX.4.21.0206061947590.19481-100000@dns.toxicfilms.tv>
Reply-To: netfilter-devel@lists.samba.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Maciej Soltysiak wrote:
> Hi,
> 
> 
>>A Solution:
>>-----------
>>As a temporary hack the following rule can be added as the second rule:
>>
>>iptables -A FORWARD -p tcp --tcp-flags ACK ACK -j DROP
> 
> Well, i think everybody who gets to that point uses:
> iptables -A FORWARD -p tcp -m state --state NEW --syn -j ACCEPT
> 
> type of rules. new + syn.
> 
> 
>>However, this is not a solid solution and the code should be modified,
>>as we see it, not to recognize ACK packets as being in the state NEW.
> 
> I belive that state NEW says: a packet never seen before. A tuple that
> does not exist in currect tracked connections table.

So, what are the INVALID packets ?????


According to my poor knowledge of TCP, I was classifying the NEW packets
as the packets which were part of the first three way handshake:

SERVER (LISTENING)                       CLIENT (CONNECTING)
                            SYN
                    <-------------------


                         SYN + ACK
                    ------------------->


                            ACK
                    <-------------------

                     3-Way TCP handshake


After this, I was assuming that we were in the ESTABLISHED state.

Regards
-- 
Emmanuel

Premature optimization is the root of all evil.
   -- Donald Knuth
