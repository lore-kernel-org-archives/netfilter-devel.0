From: Friedrich Lobenstock <fl@fl.priv.at>
Subject: Re: latest pom: base/connlimit breaks kernel 2.4.25 compile (+possible
 fix)
Date: Sat, 10 Apr 2004 21:17:27 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40784847.6090205@fl.priv.at>
References: <40780CAD.6080305@fl.priv.at> <4078264C.5000909@eurodev.net>
Reply-To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <4078264C.5000909@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Pablo!

Pablo Neira wrote on 10.04.2004 18:52 MET:
> Friedrich Lobenstock wrote:
> 
>> -    /* NULL if ip_conntrack not a module */
>> -    if (ip_conntrack_module)
>> -        __MOD_INC_USE_COUNT(ip_conntrack_module);
>> +    /* NULL if ip_connlimit not a module */
>> +    if (ip_connlimit_module)
>> +        __MOD_INC_USE_COUNT(ip_connlimit_module);
>>     return ipt_register_match(&connlimit_match);
>> }
>>
>>  
>
> AFAIK, the use of __MOD_INC_USE_COUNT is deprecated, actually I remember 
> that someone posted to the maillist a related issue and Harald finally 
> decided to remove them. If I'm missing anything, please let me know.

Hmmmm....I just looked at other modules to see how they do it, so 
__MOD_INC_USE_COUNT() still seems to be in use not only in this module.

> So I think that you could remove them, you could also post a patch to 
> update the current match available in pom-ng :-).

Can I really remove those lines completely?

-- 
MfG / Regards
Friedrich Lobenstock
