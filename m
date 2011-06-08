From: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 3rd revision] Add SELinux context support to AUDIT target
Date: Wed, 08 Jun 2011 11:13:18 -0700
Message-ID: <4DEFBBBE.6090307@schaufler-ca.com>
References: <4DEDEB99.4070601@netfilter.org> <4DEDFE43.5060402@googlemail.com>
	<201106081049.48026.sgrubb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Thomas Graf <tgraf@redhat.com>, linux-audit@redhat.com,
        netfilter-devel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Eric Paris <eparis@parisplace.org>, Patrick McHardy <kaber@trash.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>
To: Steve Grubb <sgrubb@redhat.com>
Return-path: <linux-audit-bounces@redhat.com>
In-Reply-To: <201106081049.48026.sgrubb@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-audit>
List-Post: <mailto:linux-audit@redhat.com>
List-Help: <mailto:linux-audit-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=subscribe>
Sender: linux-audit-bounces@redhat.com
Errors-To: linux-audit-bounces@redhat.com
List-Id: netfilter-devel.vger.kernel.org

On 6/8/2011 7:49 AM, Steve Grubb wrote:
> On Tuesday, June 07, 2011 06:32:35 AM Mr Dash Four wrote:
>> Add SELinux context support to AUDIT target - 3rd revision (style-type
>> changes made *only* since 2nd revision of this patch). Typical (raw
>> auditd) output after applying this patch would be:
> <snip> 
>
>> @@ -163,6 +170,15 @@ audit_tg(struct sk_buff *skb, const struct
>> xt_action_param *par) break;
>>  	}
>>
>> +#ifdef CONFIG_NF_CONNTRACK_SECMARK
>> +	if (skb->secmark) {
>> +	  	if (!security_secid_to_secctx(skb->secmark, &secctx, &len)) {
>> +			audit_log_format(ab, " obj=%s", secctx);
>> +			security_release_secctx(secctx, len);
>> +		}
> else
> 	audit_log_format(ab, " osid=%u", skb->secmark);
>
> _All_  audit code records the number on a failed conversion.

But it really shouldn't. An unconvertible secid is indicative
of a serious, unrecoverable failure within the LSM. It's every
bit as bad as an invalid pointer.

> -Steve
>
>
>> +	}
>> +#endif
>> +
>>  	audit_log_end(ab);
>>
>>  errout:
> --
> Linux-audit mailing list
> Linux-audit@redhat.com
> https://www.redhat.com/mailman/listinfo/linux-audit
>
