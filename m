From: Victor Julien <victor@nk.nl>
Subject: Re: Creating rules without the /sbin/iptables command?
Date: Fri, 19 Mar 2004 20:01:48 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <405B439C.7090009@nk.nl>
References: <Pine.LNX.4.44.0403190042550.32344-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Developers List <netfilter-devel@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.44.0403190042550.32344-100000@filer.marasystems.com>
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
>>using 'iptables-restore' (without noflush) is there a way to preserve 
>>the accounting data from the first rule?
> 
> Then you must use incremental commands, keepint the accounting rule 
> untouched.

Hmmm, that i don't want.

> 
>>Is this what the -c option of iptables-restore is for?
> 
> No. This instructs iptables-restore to restore any packet/byte counters 
> found in the input data. Without this option any such counters is ignored 
> and the installed rules have zeroed counters.

So i have to read the current counters first by parsing 
'iptables-save'-output. And i can then recreate the rules and set the 
counters to their old values?

Using 'iptables-restore' can i flush one chain, but leave another 
untouched? If so, i can create an accounting chain which will not be 
flushed...

Regards,
Victor

> 
> Regards
> Henrik
> 
