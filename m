From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: [Fwd: Re: Re: [PATCH 2.4.37] iptables: handle IPT_RETURN from
	user target]
Date: Mon, 23 Mar 2009 16:26:36 +0800
Message-ID: <412e6f7f0903230126x3ee972b5se1005cc3b5895bce@mail.gmail.com>
References: <49C12888.3000907@expand.com> <49C12911.2080507@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: haimdaniel@gmail.com, netfilter@vger.kernel.org,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <49C12911.2080507@trash.net>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

I posted this patch before. I am glad to see someone has the same
requirement as me. It is useful when implementing ACL. Such as these
statements:

if (x_cond) {
   do_x;
} else if (y_cond) {
  do_y;
} else if (z_cond) {
  do_z;
}

Because the current iptables doesn't support multi-targets, we have to
do this kinds of things in a dirty way.

On Thu, Mar 19, 2009 at 1:02 AM, Patrick McHardy <kaber@trash.net> wrote:
> Haim Daniel wrote:
>>
>> Patric McHardy wrote:
>>
>>  > And what module will be using this?
>>  > --
>>
>> Currently there's no such module in the src tree. I've encountered the
>> problem
>> myself when I needed to write a proprietary module for the company I work
>> for.
>> I've seen prev posts on the subject as well.
>
> You'll have to carry this patch yourself. Until we need it for something
> in the mainline tree, there's no reason to change it.
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Regards，
Changli Gao(xiaosuo@gmail.com)
