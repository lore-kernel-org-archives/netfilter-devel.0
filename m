From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH]: fix all iptables problems with '!' (hopefully)
Date: Wed, 08 Jan 2003 19:37:10 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E1C6FD6.8040603@trash.net>
References: <35565.195.97.5.193.1041816667.squirrel@fs.tsaousis.gr> <20030106020219.GC423@comet.rv-int> <3E193B0E.9030602@trash.net> <36373.195.97.5.193.1041856153.squirrel@fs.tsaousis.gr> <3E19A1D8.7080605@trash.net> <20030107171526.GL1353@sunbeam.de.gnumonks.org> <3E1B222B.5030009@trash.net> <20030107201643.GY9467@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <20030107201643.GY9467@sunbeam.de.gnumonks.org>
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

>>What about if i convert all matches to only show "!" in boolean context 
>>in the helptexts and change check_inverse and what else might be
>>neccessary to enforce this ?
>>    
>>
>
>I think this is a wise idea.
>  
>
Since i have to touch a lot of helptexts anyway i thought it might be 
the time to unify their format.
Any wishes regarding this ?

Regards,
Patrick


>  
>
>>What about backward-compatibility ?
>>    
>>
>
>This is usually not my idea of being user-friendly... but considering
>how much trouble we've had with this over the last couple of months, I'm
>willing to sacrifice a bit of backwards compatibility.
>
>To everyone: Please feel free to protest.
>
>  
>
