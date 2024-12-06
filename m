Received: from sonic303-28.consmr.mail.ne1.yahoo.com (sonic303-28.consmr.mail.ne1.yahoo.com [66.163.188.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D219F206289
	for <netfilter-devel@vger.kernel.org>; Fri,  6 Dec 2024 21:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.163.188.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733519291; cv=none; b=XjBnULViedF8Y5m3OgKwSXxsIyj5c97rzWZDXvQxSzJ/zOmuYgwulzk1g87TZXP/e8rao9hgDKxgNNeEJ3rkZr0l2bjbU+UW4dYVmVzFaQMQeL7mORONbfvee2/l1tz0UrtCZS9C5BI9KW5i+dEnCvsXNbupdUjdY5IR37dXg18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733519291; c=relaxed/simple;
	bh=HFCwGUFiueafm2TV1Op5osl0zuha+uNJg5IXcEByN/8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sfJyCt24BrJbH5ctKweLRDZKGp4cJgqGi5bEEAU9dd2tPKfwFcKTin0xpNno0E9lvCHrM9RpOUoY+bqUx1DqsXxyN0GXpcov5V/Upr8AmCtwNfuFQRTWhZWWU06cZCOimxSyiznliGbh88bI//INCeJdrSPEQzMxwWE8AbOrHvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com; spf=none smtp.mailfrom=schaufler-ca.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=UYvx2XNV; arc=none smtp.client-ip=66.163.188.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="UYvx2XNV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1733519283; bh=HFCwGUFiueafm2TV1Op5osl0zuha+uNJg5IXcEByN/8=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=UYvx2XNVZ1j6Be2j41EKie5v+d1La+kjPf47DlTKk/BdVmn+VUypusRPqlAc6503fOLF3wAwCrQ3cYJGcKxWB/p2waV5MjlcV8PQCf/cRp17B+VaBw273p9kKPTvMaaXic8Xk6AdYwURx/qdz/AmkDt19WsblkvurPwWrtXgq/MHjmIJJdEaKX2MfE5NmsX5SUMZkQqw+G1fGp1D9DkiC2N7Wq8uaz/j81bsiQ6M5pwiPIq/jk2ql+QRpYkKv3uzUsS+GQxfi2qVGfFPc06uMn3TDqy5g/IA24RA908rqII+MGslcsJpP/RMlDQxhOl431SMrxIiXVexFd3/7NZisw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1733519283; bh=O9QcMyL7oH3n+wpXdca1wByE+kCFVXyZmoosOu+ZS/y=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=BoLJkmN/THQKY8k2J4bEdP5NdFsibu4kt/CLjzUAHclF93VRj1FvC2rIlh5NrP0fPCDOBXc2Fve+rZHXD+dazqOfQJ4KtQBW1AzSYhf9QLzVeQJfIIHLq53OI20e059UZUJ/kb2qTcKcHEbB16tkkYWowoij8DcsFK/pAjbipRo7l4CQZBLxhtrAleUG2fkNIaf/IbQqY0wzAmumPuiw8F48K7W8ME7r2qQx4p52I8wFxXOV8VaCAbWzkygvIc4+yF5KOBcEEFlSkgRqvNEhrLI54xc+6HlFO3Sc3rR/toWCl7q8irhpof0Jk3v7clRMD9Tg4+0QkG6hvoNUUG50nw==
X-YMail-OSG: 60rKrgsVM1lvY6J2WLM.ZIV0sTeFEfdmhxDvFrJ35uDWPyaYVdmmIB7OJBzGrfZ
 vXBNEUllrZbuiNXLcCwk_0zv4vYq3XbHJ3MYgvgbh56Wi4pC22bTKOs5Y9ZuJXxz1pUfzAIgZblO
 q78_MC.7KURHXh4zM9VlK8F2sYa98VF1bg37D4aKTrL6gswXAf6WAOU8jBUUfcmmnDUTMYcsyjYi
 S9q_ktECMkaiJh4dEtgyOT81h5i3gfOB5MPHo5oRn9s8Ie2s3wVy3tnv.XDGnSKVXcLZSfmO.Gst
 L1EIpOtNhVdnHbK2ZFGzKnVo6o8DDnbTDHjg8TrH5CDfiCSRqNVGsv7uVvMcJfHOLXPvG0fAfROG
 L7buDqXdbYJuoKf3mUDlHprK30g.0mQaP2PrS4ATNmUDrmvi8RJeq2_ENRAtOcFoqciF2dfETCoc
 tpTrRBGyH4AsEDBwdjh2dSUUqyeoeBmnSL_fObmhEjD.ZqD759JgtHCtdQsDyCJOoZAoV_7y.cFB
 K2T4yWjrg50vxqBt7W1IvEu1opyCFCXlGva9VHQDyKUN8St0vygPG6QQSSuUjf_eaRbVLw3N9347
 LDTHXSOxo0rQigfW5HrULXfb7c0Ryiv1chJl.MJp5amNv_VIuk7iUnT8R4pJQbPe_qaf42wT3ohK
 BYWfo2XwRW06xSvVrnEt1Kof0xBHO1Wcj_CNae6buktTmEpw8b5fnk9xlWPsMMYBuxLOMgUftvJl
 MOwJ1s.d6iYU0KZ7t4Eknfci3ZG_7nj8mEYlculokbcvnoOhZ0SY4EJz2S4nk62_O6RueMM8W2Ct
 iuCbegh1X8JwiS7LSwZ5lU2JanAPhS7pcrxSTMDGqEXzSIpttM2Ya0TW28WAIfTstnzyZ4XYdell
 mDZh0jxuZygC.GiPYfZEbnceZhOiBC3w67RRCdPObZ6vAArm2w50KTMY0K.pSj8vEvusB0byFrgI
 xh2CW0LhS3391wQ3wb215NsUEVzSl1_DqQE4WVKEjjh5TUBNPBh5HUiyqBN4EeXVCcybNpby1GT3
 h1lwyPdXrX075a9Apm6KL4510i8Q355pXyx4qokKysYW5MyApLlVPJnfKT_p7b13s.vuMTcLVEDt
 pE96uEJmxlmMe76lwh2oMked9yWPM3dO0Fsb4xiTlfwEMuj_YgHxJhjjlOTqq1tdPWpqgSowJ5bi
 jLVpXaarsBk2s3K8Dvm_JSjMcWnPWTzVYG7kHi6KzwtCyzB0NhRXoMHU1uD9qjOnbQcZX_dVKzGz
 4DdaMeONXGoKEdgyZjPKKyEdS0I12NxbOEbasB1NcfnSRWZsks3TIwOj8n3qi0zQ53WqSff.ODlU
 V1tXrwaD1hUJnoJj3Cl07VbilzWIX9h9JnyroDrJGIcGMXqYZUlfesp4KzvcFF47Z.xaQia0JkGM
 6qwlsL6BtZ4Anf0YAXqms2TVU085N9u1dFmzi0Y6gYOjkB6tsxmiZGCmlj4yOWjV9HHU8W5bjUka
 adOpiAj_6vL8PHytPVfiBpBRB9ZzCWymJPOtluzJqGd2M8cR6aj5JS08yiOYBLPawaqPtxJwLcge
 UDPA014XTFBkPYYbL.KKrAHY93Bjjv13fbXiF_1ewSLSXbpbf3lKHnuabINSgrYM5ZbHix8S.Hfs
 0jD5La.zVX007X1ejjrBbW8xgDHj3nMHTCTeVZzjXbz86kQRMt7h0dGJ4qw5XaYQzq5XTt5dyDns
 n3iXtoJyX8bckI3dCYPhaP5xEcYWnTFCKwgk4opxQ33mfREKPOKT5u0NmLOH9q3kdX2i.dwkp62.
 E3i79Pli_nmjyhlE_wkdz3kJvxG9kUBaklj8a8ypPfnv4PErAo3lnj.DGBd2a5kTsHKxAgKTBbOU
 ydL2R9U4.lgmcVdE5zDl6Nf4t0a3G3ZXZciphkKTnVZ5qQfrAeSBW849NFgRhRjp9_WISgCA6P_f
 gaQaJi4RYFnBrnM3pVcfUgOj7XUmDAGNnrWz8S23s4sYHD2ueYyu1i4fu9LAJhME1pNsJB9ZdwvK
 Dqy.9Uj8rGUzM7dCVtJodtmtqAxKJG9KkKQX9G.Mj0nP6na.wTyTpQJAlb3VzLolmtfVzt3bf9hd
 H2ZhuilnGtj3xRE7Q4xi5H8Res4X5BHas3ZWyqye5a1iO01thNhVxkPA17qo9tf.Y_SV5FNozMQo
 brtnCVLXbJMS8xm7gv4ULOLBZ9KHFD8V.l1EkpjhI673ncQNbA3wGIo2ItET.m0JeGjdp_4cWfpU
 s_vOL_988xK_1xdx4wExY698gWSnOAB4.TB5aUtgsJ5WFOOECO7256hwENUoa2.zZCc.yZGnm33_
 PdFHZ1ixnlyk6FnJHj6CA0_StHLY-
X-Sonic-MF: <casey@schaufler-ca.com>
X-Sonic-ID: 07789bf7-90b0-44db-b950-a9f732bbb14d
Received: from sonic.gate.mail.ne1.yahoo.com by sonic303.consmr.mail.ne1.yahoo.com with HTTP; Fri, 6 Dec 2024 21:08:03 +0000
Received: by hermes--production-gq1-5dd4b47f46-ps69l (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 3b472a536ded25bdd29cda8fa7614940;
          Fri, 06 Dec 2024 20:57:54 +0000 (UTC)
Message-ID: <3db0da6b-4c09-43e6-a75c-c38353e191b3@schaufler-ca.com>
Date: Fri, 6 Dec 2024 12:57:52 -0800
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/5] LSM: Ensure the correct LSM context releaser
To: Kees Bakker <kees@ijzerbout.nl>, paul@paul-moore.com,
 linux-security-module@vger.kernel.org
Cc: jmorris@namei.org, serge@hallyn.com, keescook@chromium.org,
 john.johansen@canonical.com, penguin-kernel@i-love.sakura.ne.jp,
 stephen.smalley.work@gmail.com, linux-kernel@vger.kernel.org,
 selinux@vger.kernel.org, mic@digikod.net, linux-integrity@vger.kernel.org,
 netdev@vger.kernel.org, audit@vger.kernel.org,
 netfilter-devel@vger.kernel.org, linux-nfs@vger.kernel.org,
 Todd Kjos <tkjos@google.com>, Casey Schaufler <casey@schaufler-ca.com>
References: <20241023212158.18718-1-casey@schaufler-ca.com>
 <20241023212158.18718-2-casey@schaufler-ca.com>
 <78666cf5-2214-413f-9450-19377a06049e@ijzerbout.nl>
Content-Language: en-US
From: Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <78666cf5-2214-413f-9450-19377a06049e@ijzerbout.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Mailer: WebService/1.1.23040 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo

On 12/6/2024 12:05 PM, Kees Bakker wrote:
> Op 23-10-2024 om 23:21 schreef Casey Schaufler:
>> Add a new lsm_context data structure to hold all the information about a
>> "security context", including the string, its size and which LSM
>> allocated
>> the string. The allocation information is necessary because LSMs have
>> different policies regarding the lifecycle of these strings. SELinux
>> allocates and destroys them on each use, whereas Smack provides a
>> pointer
>> to an entry in a list that never goes away.
>>
>> Update security_release_secctx() to use the lsm_context instead of a
>> (char *, len) pair. Change its callers to do likewise.  The LSMs
>> supporting this hook have had comments added to remind the developer
>> that there is more work to be done.
>>
>> The BPF security module provides all LSM hooks. While there has yet to
>> be a known instance of a BPF configuration that uses security contexts,
>> the possibility is real. In the existing implementation there is
>> potential for multiple frees in that case.
>>
>> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
>> Cc: linux-integrity@vger.kernel.org
>> Cc: netdev@vger.kernel.org
>> Cc: audit@vger.kernel.org
>> Cc: netfilter-devel@vger.kernel.org
>> To: Pablo Neira Ayuso <pablo@netfilter.org>
>> Cc: linux-nfs@vger.kernel.org
>> Cc: Todd Kjos <tkjos@google.com>
>> ---
>>   drivers/android/binder.c                | 24 +++++++--------
>>   fs/ceph/xattr.c                         |  6 +++-
>>   fs/nfs/nfs4proc.c                       |  8 +++--
>>   fs/nfsd/nfs4xdr.c                       |  8 +++--
>>   include/linux/lsm_hook_defs.h           |  2 +-
>>   include/linux/security.h                | 35 ++++++++++++++++++++--
>>   include/net/scm.h                       | 11 +++----
>>   kernel/audit.c                          | 30 +++++++++----------
>>   kernel/auditsc.c                        | 23 +++++++-------
>>   net/ipv4/ip_sockglue.c                  | 10 +++----
>>   net/netfilter/nf_conntrack_netlink.c    | 10 +++----
>>   net/netfilter/nf_conntrack_standalone.c |  9 +++---
>>   net/netfilter/nfnetlink_queue.c         | 13 +++++---
>>   net/netlabel/netlabel_unlabeled.c       | 40 +++++++++++--------------
>>   net/netlabel/netlabel_user.c            | 11 ++++---
>>   security/apparmor/include/secid.h       |  2 +-
>>   security/apparmor/secid.c               | 11 +++++--
>>   security/security.c                     |  8 ++---
>>   security/selinux/hooks.c                | 11 +++++--
>>   19 files changed, 165 insertions(+), 107 deletions(-)
>>
>> diff --git a/drivers/android/binder.c b/drivers/android/binder.c
>> index 978740537a1a..d4229bf6f789 100644
>> --- a/drivers/android/binder.c
>> +++ b/drivers/android/binder.c
>> @@ -3011,8 +3011,7 @@ static void binder_transaction(struct
>> binder_proc *proc,
>>       struct binder_context *context = proc->context;
>>       int t_debug_id = atomic_inc_return(&binder_last_id);
>>       ktime_t t_start_time = ktime_get();
>> -    char *secctx = NULL;
>> -    u32 secctx_sz = 0;
>> +    struct lsm_context lsmctx;
> Not initialized ?

Thank you for the review.
It makes sense to initialize it here. I will make the change.

>>       struct list_head sgc_head;
>>       struct list_head pf_head;
>>       const void __user *user_buffer = (const void __user *)
>> @@ -3291,7 +3290,8 @@ static void binder_transaction(struct
>> binder_proc *proc,
>>           size_t added_size;
>>             security_cred_getsecid(proc->cred, &secid);
>> -        ret = security_secid_to_secctx(secid, &secctx, &secctx_sz);
>> +        ret = security_secid_to_secctx(secid, &lsmctx.context,
>> +                           &lsmctx.len);
>>           if (ret) {
>>               binder_txn_error("%d:%d failed to get security context\n",
>>                   thread->pid, proc->pid);
>> @@ -3300,7 +3300,7 @@ static void binder_transaction(struct
>> binder_proc *proc,
>>               return_error_line = __LINE__;
>>               goto err_get_secctx_failed;
>>           }
>> -        added_size = ALIGN(secctx_sz, sizeof(u64));
>> +        added_size = ALIGN(lsmctx.len, sizeof(u64));
>>           extra_buffers_size += added_size;
>>           if (extra_buffers_size < added_size) {
>>               binder_txn_error("%d:%d integer overflow of
>> extra_buffers_size\n",
>> @@ -3334,23 +3334,23 @@ static void binder_transaction(struct
>> binder_proc *proc,
>>           t->buffer = NULL;
>>           goto err_binder_alloc_buf_failed;
>>       }
>> -    if (secctx) {
>> +    if (lsmctx.context) {
> From code inspection it is not immediately obvious. Can you
> guarantee that lsmctx is always initialized when the code
> gets to this point? Perhaps it is safer to just initialize when
> it is defined above (line 3014).
>
>
