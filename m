From: Victor Julien <victor@nk.nl>
Subject: Re: Creating rules without the /sbin/iptables command?
Date: Thu, 18 Mar 2004 13:49:08 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40599AC4.6030504@nk.nl>
References: <Pine.LNX.4.44.0403180900100.25678-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Developers List <netfilter-devel@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.44.0403180900100.25678-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Henrik Nordstrom wrote:
> On Thu, 18 Mar 2004, Victor Julien wrote:
> 
> 
>>Okay, lets see if I understand what you mean. Say i have an initial 
>>ruleset which looks like this, loaded with 'iptables-restore':
>>
>>*filter
>>:FORWARD DROP
>>-A FORWARD -p tcp -s 192.168.0.1 --dport 80 -j ACCEPT
>>-A FORWARD -p tcp -s 192.168.0.2 --dport 80 -j ACCEPT
>>-A FORWARD -p tcp -s 192.168.0.3 --dport 80 -j ACCEPT
>>COMMIT
>>
>>and sometime later i want to replace 192.168.0.2 by 192.168.0.4 (in 
>>exacty the same place):
>>
>>*filter
>>:FORWARD DROP
>>-D FORWARD -p tcp -s 192.168.0.2 --dport 80 -j ACCEPT
>>-I FORWARD 2 -p tcp -s 192.168.0.4 --dport 80 -j ACCEPT
>>COMMIT
> 
> 
> Or you could
> 
> *filer
> -R FORWARD 2 -p tcp -s 192.168.0.4 --dport 80 -j ACCEPT
> COMMIT
> 
>>and then 'iptables-restore -n', right?
> 
> 
> Right. Or you could even have iptables-restore -n running on a pipe 
> already.. (but beware of memoryleaks in libiptc)
> 

Okay, i think i'll rather open the pipe on demand.

>>But the easiest way is to recreate the initial ruleset with the updated 
>>rules would be:
>>
>>*filter
>>:FORWARD DROP
>>-A FORWARD -p tcp -s 192.168.0.1 --dport 80 -j ACCEPT
>>-A FORWARD -p tcp -s 192.168.0.4 --dport 80 -j ACCEPT
>>-A FORWARD -p tcp -s 192.168.0.3 --dport 80 -j ACCEPT
>>COMMIT
> 
> 
> Depends on your application, but yes I find this easier most times.

Good! But if i have a rule for accounting, how does it work then? If you 
consider this (useless) example:

*filter
:FORWARD DROP
# account the traffic for 192.168.0.1
-A FORWARD -p tcp -s 192.168.0.1
-A FORWARD -p tcp -s 192.168.0.1 --dport 80 -j ACCEPT
-A FORWARD -p tcp -s 192.168.0.2 --dport 80 -j ACCEPT
COMMIT

if i now want to reload the rule set to

*filter
:FORWARD DROP
# account the traffic for 192.168.0.1
-A FORWARD -p tcp -s 192.168.0.1
-A FORWARD -p tcp -s 192.168.0.1 --dport 80 -j ACCEPT
-A FORWARD -p tcp -s 192.168.0.12 --dport 80 -j ACCEPT
COMMIT

using 'iptables-restore' (without noflush) is there a way to preserve 
the accounting data from the first rule? Is this what the -c option of 
iptables-restore is for?

>>The last method should still be way faster than my current method, i 
>>guess. Is this right?
> 
> iptables-restore is quicker than iptables as soon as you have more than
> one modification to the table. On single-rule operations it is identical
> to iptables.
> 
> if you use a pipe to a already running iptables-restore then it isfaster 
> than iptables even on single rule operations.
> 
> In addition iptables-restore allows you to atomically replace the complete
> ruleset without race windows. This can not be done with iptables and with
> iptables packets will be forwarded while the new ruleset is only
> partiailly installed...
> 

Sounds like what i'm looking for...

Regards,
Victor
