From: Emmanuel Guiton <emmanuel@netlab.hut.fi>
Subject: Re: Sequence number translation explanations.
Date: Mon, 29 Mar 2004 11:12:15 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4067DA5F.9020102@netlab.hut.fi>
References: <4065A500.8060107@netlab.hut.fi> <20040328183643.GW7039@sunbeam.de.gnumonks.org>
Reply-To: emmanuel@netlab.hut.fi
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Harald Welte wrote:

>On Sat, Mar 27, 2004 at 06:00:01PM +0200, Emmanuel Guiton wrote:
>  
>
>>Hi!
>>
>>I need to translate sequence numbers between the two networks that are 
>>separated by the firewall. In fact, I just need to translate on of them 
>>(so tcph->ack_seq in one direction, and tcph->seq in the opposite 
>>direction).
>>I found the ip_nat_seq stucture and the ip_nat_seq_adjust function but I 
>>do not understand them. Particularly this "correction_pos", what is it?
>>
>>Could someone provide me with some explanations?
>>    
>>
>
>It is for inserting/removing bytes from a TCP stream, as needed with NAT
>of protocols like FTP (IP address printed in ASCII has different length,
>compare strlen('1.1.1.1') to strlen('255.255.255.255').
>
>correction_pos is the position (sequence number) where the
>addition/subtraction occurred, and offset is the number of bytes added
>(positive) or removed (negative).
>  
>
Ok, then it does not fit my problem. I will operate the change like for 
the TCP port number.
Thanks!

           Emmanuel
