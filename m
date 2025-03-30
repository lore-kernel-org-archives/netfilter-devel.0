Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9653C86321
	for <netfilter-devel@vger.kernel.org>; Sun, 30 Mar 2025 10:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743331601; cv=none; b=l2A2ZgRxzIlsmhBLcpfK8N3Bf2eCB1iooSegt2WQkj6qKquI0Hy09bDYlV3XXp+nta/Jqv+r0OpQ2DwQepaY9IdFISkRjaPvMQCw+huUy6i3jZ6Dn29Z5eHHmLJVFxpXMu0nC3HaA27rHvLStd4l65SGZSAJ3EOHj2o6XFbu6A0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743331601; c=relaxed/simple;
	bh=le6uiEJ0m2bUySTAxV3AHaXJ7K/4Ny/CMYG2WZbLhRk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lcGlDKaonoZt6+1o0zNG97Qhtgw3UWI7cQ1Nf8aAR+T5+NlKdVmPwcffiNB3/UF906PC9L98ROh89lK4dvLR8HmQwD8GfwOEYyIrQZdhtxfAaN0DTC3IBzQm/x59IUjGs9UZJd1yJiIWp+5gCr5MW2HlpJziPjUZ0uQYhIeOorc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b=FnQYGywi; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b="FnQYGywi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1743331596; x=1743936396; i=corubba@gmx.de;
	bh=le6uiEJ0m2bUySTAxV3AHaXJ7K/4Ny/CMYG2WZbLhRk=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=FnQYGywivfyBZF7w1qmKnuLas8YpqAgabh3mB65l5iMLJCe7LhCffZyuvv7CBWd2
	 iLfq7G8aW0x7mcXCjH5L5tcwqEctkbVHVCzCjbfM0xk2ws8G5wqMP8LsOeuQiPyza
	 oUyESN8SVYsAYUcZOjgNtCdxGAHSLNzHE4USjv7HQAgQGO5na7idF9EXGVMleXP//
	 /1OQd34731RBGOdWqcaMJkXsIM8XroBaSTYiVrYegymZ3c0V+W8jOPpDFH0jt8cWa
	 zT/g9T9cWJq58aODflz+djPcOv7IvrzBK0ydh+9y+4rOovKFiehIZeaMBM/keU+Z/
	 9z81cl+mQwYFWaGgig==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from 127.0.0.1 ([94.134.25.34]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MaJ3n-1tdiqP2myz-00SiJ9; Sun, 30
 Mar 2025 12:46:36 +0200
Message-ID: <dbaab70c-aa2f-4ef9-b004-b224210e3353@gmx.de>
Date: Sun, 30 Mar 2025 12:46:11 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH ulogd2 1/2] ulog: remove input plugin
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
References: <23db0352-9525-427b-a936-c8ef87e4d5b7@gmx.de>
 <20250329133121.GA19898@breakpoint.cc> <20250329140007.GB19898@breakpoint.cc>
Content-Language: de-CH
From: Corubba Smith <corubba@gmx.de>
In-Reply-To: <20250329140007.GB19898@breakpoint.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:C7HH7TOGjhlJgCo4IHe64l8uadBvwfGQfZCTUuhjM63XwL11D5f
 k7GIeIEMJklIvRNN4LFCcy0UIAPaqqZn4PI0+QKNsEwDlIPrSLoFjw85yxNXTfdkGHIBmSs
 V+eYOLmsr0TTtuk1IbgkpBsGN/P2SH59MSJncxlSQWnkRpEIrdBBVx766DG4sbpzYp6Fr9E
 xpfSn493flxZ5I6abEU2Q==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:ljYdKU3dQDg=;c3zLqonXq+dQ6B40+t+ncs+ddQ4
 joN0DhnyfvrqKBjWqriUVDgl6tNIa3QNqiDBTv49kIo3mJ1lgxm5UesAHJfekCOxxQgVKnDJZ
 SeEwexGRL+wYHfjaoNTINIqXX7/ut2LUXkXILWEyOc/YTy0Qz5MoXEiuVnhgxjG2MUSQ1OaXF
 z3zT49NfWV4dBGoDH+DzOiWOxdydJHoWx9pA52l9+uoLKCAhBXYObRwFtDyXVsux23knNPHZ6
 aIU9oPM34SkCuEEm2t+ElYIzo2Qp5Jl6UiSDL2eNcD5ocXqso+s3OUyQZDslSxVg9dygWfl0V
 W+jNvD1nC9h8irSqnWsKV9xy7silLVEc5djDnI9BN7WkTSyScX3zU4qHya40mI+K2kMgzq8wf
 t7reANSO5o+g9uDCzWFJojdvg7HBYQXEkA4EEh3zZgKcvXvVRd0w6f3ufTabg1K9fiPXhwoop
 7cAWOzJMCICaLa/6okZxhV/tnmBb2HKJdPbFyMxqv0nqLsjkA5fypImp2mSwb+saJDo9VLHaX
 IMRItdXyGH9BFDtBD3Ug4KZOTU+8Htd0NdmBEkKzAhd6ri8YRFliu061bA067niFpZBLOjps8
 rpl9q7XZgR8Cn+GvhvatSXj4Y/UwfidekJN+QNER+gypiHWTY6EHshMUgRUbEpOLpp+EA80Qw
 BgS+GYbBYHMmBMTGCBpDqi5q6YTZY3PFuQQ9McAK+VQDsTyEHHxb6hWpukWzjRYgHWHJENuoA
 saEvlmctq8fchqXystIvP+ekoYpFOc3r8bsPk8ak94q93WVQpms+TSPfqgA/ERIiRvrE6dokQ
 1LPsD/ZhzrdL/TfEYL8Y+IhFpB+r4rZxN4gjZFGMxI6XvlVhtp061I2f9C8fqt8NCSSlacv77
 k2uqYyietx1vWMezJGuCJnxLwUhOy/AiX27aYGE58YLBcANtcvgBU6+2zaKSijdNa6Boxj2x4
 6cvaeP1FVgPV3acKi8/7JdsOFTxsVRpEAV1gwT690L8W8u7FSTRTTKdgP6aUhiXCeQyPi0xF7
 eZ2hUwnD205Bf6kXDKdsrhFtEZei1ChQNYMpYt3lAOUyv/6lYThCq7jDFg7tewoJGHYQWRMLu
 kq32sGBI+Jxv7imLGyrNELRMFCb/McbmLYqvBxQZ5v8ErvGwvrWHfRilytoypRM8y8LMqCGVH
 olAH0qs1L7UFHiTzEOczYHTvhOPQSjs2gFmWkEYx88MxdhymDhAaMEZByRYarntlr9R8XA5Ub
 GoEFXrLqEB39oA562dUNsPIKQ9E4hMqfN3tsyDF9CBmDcjE0d56h273UhWxx7U67Ehd93yW+u
 xaDAMKcnQGPA0DBozzK1q7XtKEhqzST5urCwnRUVOJsGGT0/gO4TBCT14kgW5LczWxIHhFqQ9
 I0nm6euHrqSL6uqGiTLfQ5UWNAnvFbQMHXOeMeB5wzckHNjp+63EijGlEAefkRoMqpvUt1NAx
 MoA1jxjXguScfQaHZrWqrZfNl5vg=

On 3/29/25 15:00, Florian Westphal wrote:
> Florian Westphal <fw@strlen.de> wrote:
>> Corubba Smith <corubba@gmx.de> wrote:
>>> The ULOG target was removed from the linux kernel with 7200135bc1e6
>>> ("netfilter: kill ulog targets") aka v3.17, so remove the input plugin
>>> for it. It's successor NFLOG should be used instead, which has its own
>>> input plugin.
>>
>> Your email client is reformattig parts of the diff:
>> % git am ~/Downloads/ulogd2-1-2-ulog-remove-input-plugin.patch
>> Applying: ulog: remove input plugin
>> error: patch failed: doc/ulogd.sgml:132
>> error: doc/ulogd.sgml: patch does not apply
>> Patch failed at 0001 ulog: remove input plugin
>> hint: Use 'git am --show-current-patch=3Ddiff' to see the failed patch
>
> I resolved the conflicts locally and applied the patches, please
> double check that I did not miss anything.
>
>> https://patchwork.ozlabs.org/project/netfilter-devel/patch/23db0352-952=
5-427b-a936-c8ef87e4d5b7@gmx.de/
>>
>> Can you send the pach to yourself and make sure "git am" can apply it
>> again?
>
> FWIW, it looks like something in the delivery path removes trailing
> spaces, turning "some line \n" into "some line\n" which will make git-am
> fail as intree and diff don't match.
>

It appears that my mail provider *sometimes* converts to a different
Content-Transfer-Encoding, and in the process removes trailing
whitespace. Apologies for that, and thank you for the feedback as well
as resolving it on your end. I will look into preventing that from
happening again.

`git diff HEAD..origin/master` shows no difference between my original
local branch and the updated remote branch, so from my point of view
the patchset was applied as intended and there's nothing missing or
extra.

