Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CABF91DE894
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Mar 2025 18:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741805340; cv=none; b=o+t9X/nNlYTzbbm+9Xd5vyKO3BmVNkcgzuBpJPnmlanVfcrXotylyL0XyOm6I0GdJIpcD5s0kMujK551VKG69BmGiINVY10UvIh8Wq6LHNIPzYOEAdAsFQR1/9RmQ0o78UbYBZb5dG8ib1gkjc/wt8GlF508HEGoMzhbFGFry3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741805340; c=relaxed/simple;
	bh=XDebn61bxIeWe3lRa5PBY6ejsZsIS0ARdqlPxcnLFzg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OHb0DL0gmXkPrBBwxz+vfilv78r2Zj6atA9f73npq2lsG+rZzqhuY14kQE0yYY9WD0czhR4lPd0WZe/2VXgKPllSQWuTF8Tm7U8Uajp8hyGfvJFtBLyDPfBG0Hl7anlkZ/Nglti0lftgUkifPK9qZmxpu6jryF9K7BM/pho1sgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b=YyGpl6hn; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b="YyGpl6hn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1741805332; x=1742410132; i=corubba@gmx.de;
	bh=paOMK4WLhV5uyKPFC10mBbOvuDBMp+VFlbYghzDviN8=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=YyGpl6hnYWEsjh0o4HIsX/pAMGjoNJQtlsfN7Kw4jE2STtjyJKS48Cg9Wkxh3oFi
	 jqScCsagByOjaizjbIL3TorSazn5iO1xUgToCxom3WdgX9mrQC7N1iD7Yvq7rb7Nm
	 SjzwHi7il3/Y6ebC0IVIqD5J2+/28dG5nfP97iMucflI4VENoL4tjaTrNhYQfdQ3h
	 vM16G0PEpmOBw9CILZw0Q+n6FhmxPnUQpM7neJ6JOmTY4r7jFdIwHk11TJOH2gvwc
	 izCqY+As3V0xQm2lVFmQNYcDLa45gknQlYl7uVaFKqZPNkdzQum4YJXv83zDGL/gc
	 S2NsA6v3Mrz7eIQ2OA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.44.3] ([83.135.91.254]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MKbkC-1te4cB3tV6-00XXFC; Wed, 12
 Mar 2025 19:48:51 +0100
Message-ID: <ccf47d9d-c620-418d-8143-589340802f70@gmx.de>
Date: Wed, 12 Mar 2025 19:48:25 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ulogd2,v2 3/6] ulogd: raise error on unknown config key
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
References: <1a5fff4d-4cef-48e3-a77c-bb4f7098f35b@gmx.de>
 <e3965ebb-b9f9-46ce-87e5-4960405dbe35@gmx.de>
 <20250312152154.GA28069@breakpoint.cc>
Content-Language: de-CH, en-GB
From: Corubba Smith <corubba@gmx.de>
In-Reply-To: <20250312152154.GA28069@breakpoint.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:LGNVjUQk08Atnullp105ee9tFaenHzl74Z7QBgaDqPSyNSIjq6+
 UAEduUJEbNZwaKbTQvrQRQcbse33FrtPdrMxvQ9uPoLXMFA6EJZBpClCxujmUMTK+eYYfH8
 HagDgYpVgJIkafGLi4h9iU38t/1acU3bSiHJtOmnF/NEktngRmqYTlh3wChDgokPrmD7+NP
 UgFSuVI7FjMBFvW6PYBvw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:KUyFhgp3WUM=;bWqQm7vVHDnf+y5GXver8xLeZ3x
 q5IbluLAJuRHleZD8KF5sEK2Qdpl7EkiIiL3T0rF3zHV9rxwk15BvZIPsVFetq2+t8EONsokB
 +JV788AmYkUmsa7QAelN8npHZAKCPEjKNLkuY9wdQnlLgXtb9fJ0Km7Z1zNI/RChIbI4IpNhK
 J6KWhTYzM9rYQToMUeGsV9GItn5PBOy3xB8ieChFSxubu9zduaTAqogfdgvM3YgN2bciuynzl
 pO8deP0q99b75gg8tfr/e5nOB1hG86FasfcOty9c+cBbE6j/kPxoiTYlRB6SZhtpl61oU/s8n
 SnKV7ycm8B/p71pEKZ5XAGrzhM8N5d2ZlCCysHn7Q1VpGF+79mfFHJb7yxr06tjfu7ide4bzd
 cAKmvMmWRpNd8w/AiNt1yxmqmyemUQ3+IJuFLl+E2zTVI3hjdXe28VhacEgAX/DGcS84EKz7u
 IcCcAWtzR/0z4JN9ZK24GHTAOsIi/6rFaWd/9PGZR97CVvjJyUIWbolST/DLJZyLgJk2wKcbn
 870LfuFa0YJeTX5Md3CDAk9S3JJ40Z+3hZEP+FOqVmgkRm/8XFzSv9sZO37nsS0Ykj7o6dO0+
 PmX2MLFvaKt9dKOJZ46g013U2KNZOznhhyKQA7FCh/7j4uwixQYvhEs55iKXeGOykh3LLvyBx
 CVUHJ92yXe253NkTV43sM99Zi8MKnqGdEq7jrLTDIBZnLcv7ARw5JlwfSCL4Uno9AgWjoWHjF
 jdTsiRtFRFTkplfezB6RLXgkngI6o9dSVNHWs7vlj3EwZ9mM8yguYFb10TfKb4MvZFrkcQhga
 /gyYjpWqeUs4bHNOjQZoa4GChjv6+oL4LAX70ot4XID1QAcVh8L4a+v3/J2D8EHXA8f6acARX
 iBZp3azd9HgqMrLVsLhyRzfUQupzzm4xaU9kJuPh4bDxrU8uXUxLUEl7hddVI9r8/Ckl3ZKnM
 JxnD1SYCBxzTQ9aJqLrHmGwRf5L30Jq8VgA0Im55TEAP3EC48QDZo5NXrZCEOx6EK1KQDw7ub
 jZ0pWqC40uz7XQwbKcXPPAKP0p2csUPYUkDzmekNFkepyFk3hJi/34MDFyt8adYRnpICbTfLA
 mrTk3hd1WZVrJipDjnQwi6cD7rUcDxiFsujiX7EcSsaBLgunvqto0iN9BHtHePeoGLtf+pZJu
 +vrj459uLWRRxLFSMl7N45JXw1nweNv89Tz3FBX4JODm5QvMRYe8PoNAHmuFeGiCUHFFKDmFK
 RnMhZ1rn8XJQGP8rGm9+r1P9fhuClDGx/ubPm60kzXa+/JkUjAcSRYIJr0dUfYup5PFkkSvrP
 umoMpe1OW/vIHgdaXypwc1zr6m7srk5CBElANvvcUZJjJXFQj3G/MAp32ftLn+znPevPFFHg2
 dKNGCt6lWINT9aAs8uSgW/7z7ThUGrsZ/jXfVEVBc8rwPn4WNBE4KHzAHvpVFFuwfGcG/8aTb
 wIphbxLK/sjr9Ot9/Zp0Id0yMXjw=

On 3/12/25 16:21, Florian Westphal wrote:
> Corubba Smith <corubba@gmx.de> wrote:
>> Until a6fbeb96e889 ("new configuration file syntax (Magnus Boden)")
>> this was already caught, and the enum member is still present.
>>
>> Check if the for loop worked throught the whole array without hitting a
>> matching config option, and return with the unknown key error code.
>> Because there is no existing config_entry struct with that unknwon key
>> to use with the established config_errce pointer, allocate a new struct=
.
>> This potentially creates a memory leak if that config_entry is never
>> freed again, but for me that is acceptable is this rare case.
>>
>> Since the memory allocation for the struct can fail, also reuse the old
>> out-of-memory error to indicate that.
>>
>> Signed-off-by: Corubba Smith <corubba@gmx.de>
>> ---
>> Changes in v2:
>>   - Reduce indentation of case statements (Florian Westphal)
>>
>>  src/conffile.c | 11 +++++++++++
>>  src/ulogd.c    |  2 ++
>>  2 files changed, 13 insertions(+)
>>
>> diff --git a/src/conffile.c b/src/conffile.c
>> index cc5552c..7b9fb0f 100644
>> --- a/src/conffile.c
>> +++ b/src/conffile.c
>> @@ -236,6 +236,17 @@ int config_parse_file(const char *section, struct =
config_keyset *kset)
>>  			break;
>>  		}
>>  		pr_debug("parse_file: exiting main loop\n");
>> +
>> +		if (i =3D=3D kset->num_ces) {
>> +			config_errce =3D calloc(1, sizeof(struct config_entry));
>> +			if (config_errce =3D=3D NULL) {
>> +				err =3D -ERROOM;
>> +				goto cpf_error;
>> +			}
>> +			strncpy(&config_errce->key[0], wordbuf, CONFIG_KEY_LEN - 1);
>
> This raises a bogus compiler warning for me:
> conffile.c:246:25: warning: '__builtin_strncpy' output may be truncated =
copying 30 bytes from a string of length 254 [-Wstringop-truncation]
>   246 |                         strncpy(config_errce->key, wordbuf, size=
of(config_errce->key));
>
> What do you make of this?
>
> -                       strncpy(&config_errce->key[0], wordbuf, CONFIG_K=
EY_LEN - 1);
> +                       snprintf(config_errce->key, sizeof(config_errce-=
>key), "%s", wordbuf);
>
>

Today I learned: GCC will print certain warnings only when certain
optimizations are applied. That warning is only there with -O2 or above,
I was using -Og. That's why I didn't see or catch it.

Your suggestion using snprintf works, but feels a bit heavy-handed.

I like the suggestion in the GCC doc [0] of using memcpy for
(potentially) not-NULL-terminated strings better. Since the target
memory comes from calloc(), the last byte will always be NULL and
properly terminate a potentially truncated string copied from wordbuf.
So just memcpy the 29 bytes before that. It may copy data beyond the
first NULL character in wordbuf, but with a maximum of 29 bytes it's
not a big deal.

So my proposed fix would be:

-		strncpy(&config_errce->key[0], wordbuf, CONFIG_KEY_LEN - 1);
+		memcpy(&config_errce->key[0], wordbuf, sizeof(config_errce->key) - 1);

Compiles without a warning, and tested to work as expected. Would you
like a v3 of the whole patch, or is this addendum good enough?

[0] https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html#index-Wstringo=
p-truncation

=2D-
Corubba

