From: Victor Julien <victor@nk.nl>
Subject: Re: Creating rules without the /sbin/iptables command?
Date: Thu, 18 Mar 2004 13:52:13 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40599B7D.8020804@nk.nl>
References: <Pine.LNX.4.44.0403180022440.15641-100000@filer.marasystems.com>	 <40594EFE.2000004@nk.nl> <1079609346.2009.9.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Developers List <netfilter-devel@lists.netfilter.org>
In-Reply-To: <1079609346.2009.9.camel@localhost>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

John A. Sullivan III wrote:

<snip>

>>
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
>>
>>and then 'iptables-restore -n', right?
> 
> I believe that is correct although I also believe you can dispense with
> the :FORWARD DROP since you already had it in the first rule set and
> could also use 
> -R FORWARD 2 -p tcp -s 192.168.0.4 --dport -j ACCEPT
> to just replace the rule although I confess to never having tried that
> in an iptables-restore file
> 
>>But the easiest way is to recreate the initial ruleset with the updated 
>>rules would be:
>>
>>*filter
>>:FORWARD DROP
>>-A FORWARD -p tcp -s 192.168.0.1 --dport 80 -j ACCEPT
>>-A FORWARD -p tcp -s 192.168.0.4 --dport 80 -j ACCEPT
>>-A FORWARD -p tcp -s 192.168.0.3 --dport 80 -j ACCEPT
>>COMMIT
>>
>>and then just call iptables-restore. This way i wont have to calculate 
>>where i want to insert the rules, this can be quite complex on many 
>>changes in large rulessets. Is this correct?
> 
> Yes, although when ISCS is released (http://iscs.sourceforge.net), it
> will provide an alternative to having to track rule order (massive
> oversimplification here but it is not the topic at hand).

But how will ISCS handle this problem? Will it also create input for 
iptables-restore? Or do you have some other method?

> 
>>The last method should still be way faster than my current method, i 
>>guess. Is this right?
> 
> I have found it to be dramatically faster - John

Good!

Regards,
Victor

> 
>>Regards,
>>Victor
