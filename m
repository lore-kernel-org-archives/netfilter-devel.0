Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6500315770;
	Mon, 18 Aug 2025 10:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.17.235.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755512446; cv=none; b=bo6zwtWhETLxzkuydDrPtx+xAEPl0N5W8XSACGt8nkaRACt1dDOjRQplxIYnhC/Jfo+jrEY+sstp7ZjEV/wDmh6Y7g1ga2IY/kWl1WaxHp4yu8Je2mWPuQKfwUy50uMrHKKMiCH5MN3zKKI5Jdf3vJoAoI5z6Bh99vZ6i617bCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755512446; c=relaxed/simple;
	bh=vVfzZiL3SHLn9VOiHd94n8EbMb/amrFrBX1QpYNDS0Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LII+/4STT3YZP2O3Wvze4WoVcxRWxW8Q0mX1lKYOhhN5LERjGpVmVNXkEMqZ9nF6+6nk0DdxVsPNAyqZq9akYsGXFx64Rcx9asA5DOTPbVJC4pPFhaDqAG8kRqeAXHuUAGhnkuyf9UFOa3aYDHFKzTih6Z3kwJSeofddwcTdEaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu; spf=pass smtp.mailfrom=csgroup.eu; arc=none smtp.client-ip=93.17.235.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csgroup.eu
Received: from localhost (mailhub4.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4c57gB3XdZz9sSh;
	Mon, 18 Aug 2025 12:07:18 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UW5otXcsL1ne; Mon, 18 Aug 2025 12:07:18 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4c57gB2nMFz9sSf;
	Mon, 18 Aug 2025 12:07:18 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 4B9058B764;
	Mon, 18 Aug 2025 12:07:18 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id ZTl45ucC9PUM; Mon, 18 Aug 2025 12:07:18 +0200 (CEST)
Received: from [10.25.207.160] (unknown [10.25.207.160])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 269648B763;
	Mon, 18 Aug 2025 12:07:18 +0200 (CEST)
Message-ID: <edfed2af-8b4d-4afb-b999-5c46b7d46fba@csgroup.eu>
Date: Mon, 18 Aug 2025 12:07:18 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: modprobe returns 0 upon -EEXIST from insmod
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org
Cc: linux-modules@vger.kernel.org, Yi Chen <yiche@redhat.com>,
 netdev@vger.kernel.org
References: <aKEVQhJpRdiZSliu@orbyte.nwl.cc>
 <8a87656d-577a-4d0a-85b1-5fd17d0346fe@csgroup.eu>
 <aKLzsAX14ybEjHfJ@orbyte.nwl.cc>
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Content-Language: fr-FR
In-Reply-To: <aKLzsAX14ybEjHfJ@orbyte.nwl.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

[+ Netfilter lists]

Hi Phil

Le 18/08/2025 à 11:34, Phil Sutter a écrit :
> [Vous ne recevez pas souvent de courriers de phil@nwl.cc. Découvrez pourquoi ceci est important à https://aka.ms/LearnAboutSenderIdentification ]
> 
> Hi Christophe,
> 
> On Sun, Aug 17, 2025 at 05:54:27PM +0200, Christophe Leroy wrote:
>> Le 17/08/2025 à 01:33, Phil Sutter a écrit :
>>> [Vous ne recevez pas souvent de courriers de phil@nwl.cc. D?couvrez pourquoi ceci est important ? https://aka.ms/LearnAboutSenderIdentification ]
>>>
>>> Hi,
>>>
>>> I admittedly didn't fully analyze the cause, but on my system a call to:
>>>
>>> # insmod /lib/module/$(uname -r)/kernel/net/netfilter/nf_conntrack_ftp.ko
>>>
>>> fails with -EEXIST (due to a previous call to 'nfct add helper ftp inet
>>> tcp'). A call to:
>>>
>>> # modprobe nf_conntrack_ftp
>>>
>>> though returns 0 even though module loading fails. Is there a bug in
>>> modprobe error status handling?
>>>
>>
>> Read the man page : https://eur01.safelinks.protection.outlook.com/?url=https%3A%2F%2Flinux.die.net%2Fman%2F8%2Fmodprobe&data=05%7C02%7Cchristophe.leroy%40csgroup.eu%7C34b49eb3d0544fc683e608ddde3a75b2%7C8b87af7d86474dc78df45f69a2011bb5%7C0%7C0%7C638911064858807750%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=%2F70LV37Zb%2FNeiBV59y9rvkLGh0xsqga08Nl3c5%2BVU5I%3D&reserved=0
>>
>> In the man page I see:
>>
>>              Normally, modprobe will succeed (and do nothing) if told to
>> insert a module which is already present or to remove a module which
>> isn't present.
> 
> This is not a case of already inserted module, it is not loaded before
> the call to modprobe. It is the module_init callback
> nf_conntrack_ftp_init() which returns -EEXIST it received from
> nf_conntrack_helpers_register().
> 
> Can't user space distinguish the two causes of -EEXIST? Or in other
> words, is use of -EEXIST in module_init callbacks problematic?

So if I understand correctly the load fails because it is in conflict 
with another module ?

Then I think the error returned by nf_conntrack_helpers_register() 
shouldn't be EEXIST but probably EBUSY.

Christophe
