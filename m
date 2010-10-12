From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/5] secmark: make secmark object handling generic
Date: Tue, 12 Oct 2010 19:24:51 +0200
Message-ID: <4CB499E3.5030305@netfilter.org>
References: <20101012154008.26943.44399.stgit@paris.rdu.redhat.com> <20101012154015.26943.18385.stgit@paris.rdu.redhat.com> <alpine.LNX.2.01.1010121824540.15529@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	paul.moore@hp.com, jmorris@namei.org, selinux@tycho.nsa.gov,
	sds@tycho.nsa.gov, linux-security-module@vger.kernel.org,
	mr.dash.four@googlemail.com
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.01.1010121824540.15529@obet.zrqbmnf.qr>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 12/10/10 18:26, Jan Engelhardt wrote:
> On Tuesday 2010-10-12 17:40, Eric Paris wrote:
>> diff --git a/include/linux/netfilter/xt_SECMARK.h b/include/linux/netfilter/xt_SECMARK.h
>> index 6fcd344..989092b 100644
>> --- a/include/linux/netfilter/xt_SECMARK.h
>> +++ b/include/linux/netfilter/xt_SECMARK.h
>> @@ -11,18 +11,12 @@
>>  * packets are being marked for.
>>  */
>> #define SECMARK_MODE_SEL	0x01		/* SELinux */
>> -#define SECMARK_SELCTX_MAX	256
>> -
>> -struct xt_secmark_target_selinux_info {
>> -	__u32 selsid;
>> -	char selctx[SECMARK_SELCTX_MAX];
>> -};
>> +#define SECMARK_SECCTX_MAX	256
>>
>> struct xt_secmark_target_info {
>> 	__u8 mode;
>> -	union {
>> -		struct xt_secmark_target_selinux_info sel;
>> -	} u;
>> +	__u32 secid;
>> +	char secctx[SECMARK_SECCTX_MAX];
>> };
> 
> If you make changes here, bump the .revision please, in here:

The binary layout of this structure has not changed, it doesn't require
to bump the revision.

>> static struct xt_target secmark_tg_reg __read_mostly = {
>> -	.name       = "SECMARK",
>> -	.revision   = 0,
>> -	.family     = NFPROTO_UNSPEC,
>> -	.checkentry = secmark_tg_check,
>> -	.destroy    = secmark_tg_destroy,
>> -	.target     = secmark_tg,
>> -	.targetsize = sizeof(struct xt_secmark_target_info),
>> -	.me         = THIS_MODULE,
>> +	.name		= "SECMARK",
>> +	.revision	= 0,
>> +	.family		= NFPROTO_UNSPEC,
>> +	.checkentry	= secmark_tg_check,
>> +	.destroy	= secmark_tg_destroy,
>> +	.target		= secmark_tg,
>> +	.targetsize	= sizeof(struct xt_secmark_target_info),
>> +	.me		= THIS_MODULE,
>> };

I think that we don't need that extra tab above.
