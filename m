From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH]: fix all iptables problems with '!' (hopefully)
Date: Tue, 07 Jan 2003 19:53:31 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E1B222B.5030009@trash.net>
References: <35565.195.97.5.193.1041816667.squirrel@fs.tsaousis.gr> <20030106020219.GC423@comet.rv-int> <3E193B0E.9030602@trash.net> <36373.195.97.5.193.1041856153.squirrel@fs.tsaousis.gr> <3E19A1D8.7080605@trash.net> <20030107171526.GL1353@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <20030107171526.GL1353@sunbeam.de.gnumonks.org>
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

>On Mon, Jan 06, 2003 at 04:33:44PM +0100, Patrick McHardy wrote:
>  
>
>>In fact ! is used in many matches in a non-boolean context.
>>After the patch is applied, both it always possible
>>(! --uid-owner xxx / --uid-owner ! xxx).
>>It would still be nice to have the helptexts unified concerning
>>the use of '!', i think.
>>    
>>
>
>This is why I'm still unsure whether to apply your patch or not.
>
>I'd rather like to enforce one unique syntax than offering two different
>options giving the same result (and possibly causing confusion with the
>user).
>  
>
Thats the reason why i was unsure weather to send the patch or not ;)
What about if i convert all matches to only show "!" in boolean context 
in the
helptexts and change check_inverse and what else might be neccessary to 
enforce this ?
What about backward-compatibility ?

Regards,
Patrick
