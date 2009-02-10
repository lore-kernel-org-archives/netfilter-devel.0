From: Husnu Demir <hdemir@metu.edu.tr>
Subject: Re: -m state is not working.
Date: Tue, 10 Feb 2009 09:07:23 +0200
Message-ID: <499127AB.2050702@metu.edu.tr>
References: <498AFBBC.20608@metu.edu.tr> <4990638A.1090208@trash.net>
Reply-To: hdemir@metu.edu.tr
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050509000705080009070201"
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from tenedos.general.services.metu.edu.tr ([144.122.144.162]:47928
	"EHLO tenedos.general.services.metu.edu.tr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750869AbZBJHH2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Feb 2009 02:07:28 -0500
In-Reply-To: <4990638A.1090208@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050509000705080009070201
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Yes,

I forgat to add that support :) But xt_state should not be seen if
nf_conntrack_ipv4 is not selected on the kernel config. It is useless without
nf_conntrack_ipv4 support.


Thanks.

hdemir.

Patrick McHardy wrote:
> Husnu Demir wrote:
>> Hi,
>>
>> I recently compiled new kernel and tried the following;
>>
>> # iptables -I FORWARD -p tcp -m state --state NEW -j ACCEPT
>> iptables: Invalid argument
>>
>>
>> # uname -a
>> Linux ng-test 2.6.28.3 #4 SMP Thu Feb 5 08:37:37 EST 2009 x86_64
>> GNU/Linux
>>
>> # lsmod
>> Module                  Size  Used by
>> xt_state                4608  0
>> nf_conntrack           64424  1 xt_state
>> iptable_filter          5440  0
>> ip_tables              19408  1 iptable_filter
>> x_tables               23432  2 xt_state,ip_tables
>> ipv6                  251328  22
>> sr_mod                 17540  0
>> e1000e                111728  0
>> ..
>> ..
>>
>> # modinfo xt_state
>> filename:       /lib/modules/2.6.28.3/kernel/net/netfilter/xt_state.ko
>> license:        GPL
>> author:         Rusty Russell <rusty@rustcorp.com.au>
>> description:    ip[6]_tables connection tracking state match module
>> alias:          ipt_state
>> alias:          ip6t_state
>> vermagic:       2.6.28.3 SMP mod_unload modversions
>> depends:        x_tables,nf_conntrack
>>
>> # iptables -V
>> iptables v1.4.2
>>
>>
>> Did I forget to add anything? How can I see what is happing?
> 
> I'm guessing you forgot nf_conntrack_ipv4.
> 
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe
> netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--------------050509000705080009070201
Content-Type: text/x-vcard; charset=utf-8;
 name="hdemir.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="hdemir.vcf"

begin:vcard
fn:Husnu Demir
n:Demir;Husnu
email;internet:hdemir@metu.edu.tr
tel;work:+903122103330
tel;fax:+903122103303
x-mozilla-html:FALSE
version:2.1
end:vcard


--------------050509000705080009070201--
