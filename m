From: Gervasio Bernal <gervasiobernal@speedy.com.ar>
Subject: Re: New target: can't delete rule
Date: Mon, 12 Sep 2005 20:45:40 +0000
Message-ID: <4325E8F4.4070905@speedy.com.ar>
References: <1126116594.3690.35.camel@Pentium> <431F6A0E.1090707@eurodev.net>
	<1126553016.15667.0.camel@Pentium> <43260E25.6020600@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7BIT
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-reply-to: <43260E25.6020600@eurodev.net>
To: Pablo Neira <pablo@eurodev.net>
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

Pablo Neira wrote:
> Gervasio Bernal wrote:
> 
>>     I did what you said, but I cannot make walk it.
>> This is my libipt_CRYPT.c
>> static struct iptables_target CRYPT = {     .name            =
>> "CRYPT",     .version         = IPTABLES_VERSION,     .size           
>> = IPT_ALIGN(sizeof(struct ipt_CRYPT_info)),     .userspacesize   =
>> offsetof(struct ipt_CRYPT_info,
>> table_alloc_ptr),            .help            = &help,    
>> .init            = &init,     .parse           = &parse,    
>> .final_check     = &final_check,     .print           = &print,    
>> .save            = &save,     .extra_opts      = opts };
>>
>> This is my ipt_CRYPT.h
>> struct ipt_CRYPT_info {         char key[MAX_KEY_SIZE];        
>> unsigned int block_size;         unsigned int key_size;
>>         struct tabla_alloc* table_alloc_ptr; };
>> struct tabla_alloc {         struct crypto_tfm *tfm;         struct
>> tabla_alloc* next;         struct tabla_alloc* ant; }; 
> 
> 
> It looks fine. Which iptables version are you using? If my mind servers
> well, I remember that there was a bug related with targets and the use
> of userspacesize in old iptables versions (<= 1.3.1). If so, please try
> with the lastest update.
> 
> -- 
> Pablo
> 

Yes, I have iptables version 1.3.1. I will try with one newer and I
comment to you.
Thanks again
