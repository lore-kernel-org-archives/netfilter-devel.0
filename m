Received: from sonic310-27.consmr.mail.ne1.yahoo.com (sonic310-27.consmr.mail.ne1.yahoo.com [66.163.186.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D41919ABC3
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Jul 2025 16:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.163.186.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752339376; cv=none; b=ai6WE78BBwRPrbg/L4MmbT9K9rksH8n5iEFpx/e/rUOq6tClpO44WqBVbdaG7Se/t3IC0KGUa4rlxOBgm+6IIkkrzsqN6GwseJ3/VZyuoxrt/ivEl3S3/2eRkUD15sNNYjxYwKB5iXXXbc2gSYn+atWgUhSkwyL8v3f42CFoFNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752339376; c=relaxed/simple;
	bh=lkBO5UM/DqFFl0tAc29b1DcmKZvW88aGatCILRC0g7g=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type:
	 References; b=QaQxzUaHfgOuKuFxYeCXLk5A2L/UIlhyMn8ZoE3w2sQgsTJKxpD6eU8hXEB4+4kJjqon9Wbr65k9By0oplFiM9IIcRAtyR+9U7AtdjhprNQSAoBq/4kzzElJ97tt0nwTNEqgMnDnkCDcC69W/JbBou2+cOTJ+5++clP+bx1W2/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sbcglobal.net; spf=pass smtp.mailfrom=sbcglobal.net; dkim=pass (2048-bit key) header.d=sbcglobal.net header.i=@sbcglobal.net header.b=DVk0kB1+; arc=none smtp.client-ip=66.163.186.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sbcglobal.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sbcglobal.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sbcglobal.net header.i=@sbcglobal.net header.b="DVk0kB1+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sbcglobal.net; s=s2048; t=1752339368; bh=mE6aQ0eFKUDQvzIh91cWihLaUGkJZ+3SDWd1uuQNKZU=; h=Date:To:From:Subject:References:From:Subject:Reply-To; b=DVk0kB1+sQHfJYQ010+ywqXuvSKABKCpT+eEPgSEv8ItHebrJilc0B/Ms/skDb6yXDW08yHfAm3eoP2b36maBYUrKmnh+2MW051LCDxL9ZXA9eGe/T8apPw8x8gZ0VylAxq04V4qZMhLR6rsHo7olULxOCltb9WiwVz7eVbaOCdmaPv3OubkwV6W34MfIBri5/91ROD/26WJdpI28Vj2BtxhI6eHNvWJGP7wBXpNmILOBjV61GNs105weepuYzZLF5CsITYXVgRQYE8e0vCtaxfn/1pN1V1A670lzgmBvEowIAAFbqVuS004ukWK8ylKL8/jYx+TZnCCTh32hc9AcQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1752339368; bh=Q37bbIvUqPwukFJDqwpDXbGJDJ9sYpq1D8eO+tmjIYQ=; h=X-Sonic-MF:Date:To:From:Subject:From:Subject; b=roeuDxzrD8p5PhWHfLXBzTriTA5cRsRw+FdLcvO4p65LZ/MxyRGbs067hm3N6bAUPYDkZ4ZmLtnI/E6ikBE8Xtl2fjBK1X+cOfgarcaVxz5pu3oOk8UOJ7Bei2ris8YaDwAieaZp9mcUN0f4xFBYf8MZGhGeY8e8qyegrxnM8FGEbIry1CHD2c/DhiYpxAV6CX94ym6LXrEAE0du3RU5/GBP8EeMwjPLzoFISi0f6w16THQR4w1RwrKl6v5xRFPeRBu/jKeSfqoPumcxSGd7x5q/Yxcsid/SshkdBeSLSY66RIPfI4GmxRlWN7+2NDIoRDA1qInOg2+dMKrlhlaMzg==
X-YMail-OSG: RwfRSi0VM1mymmvi.sB9V3W6zpSVTOTq76vl4aReAiJKJxuUWu7X4qTNqtS2xJ9
 _5WBxjfU2rOYWks.iaXWS5C5V00N3A9ztiJ51EbhEiuWQnfmxObPT5ohQFzFX7szKDasVO0G4_Pm
 14ytyT0gf_ZbF01xt0CDIBT4ZaNzsYonLpisR3FW0lt5PWILI1p1nDnhZz.Z5vtxiEtKis25K5eT
 kxm1mahBSzp.Xe3_MW8RJGiN.Pu_p9FNKMFP8fEsPdFvkwmvrq0Bk93exW9womrWrt98rksnXuYo
 IlNWpoHBVU5.CIWzwPsGs2uBDz4A1hTvf4QFpUN783vKSJx48o4Ajz2RBNqq9Uw6XK3tAxOFhpEA
 SUmaiZKZSSJp0u_z43_mVNOV5w.HEJS8QblPv1.lxx9nvY32xR187IEG6mBvS3WHeIPy3wjKXdhS
 7Psp0IwOGL.5ZyB2kANjaSGmGCf2a.mIfzQOSoecBjEw93HQDXX3Gk1asXsDhOCCSOmgR_ciVFpq
 MksC.nEBtEawkAn8SvOTwe5gKy8SxOY6wwUgvoE5MlOvuIJkvhfmkQz7z._CDzPlehVJyZ8Yoo6c
 zaK_fBfoaRo4giedJIzuL3Ivg3.vWnQGY_6EBXaMO3_wl6hjPpdbPUqsiUSJBoIfxvoE4ce4fv8y
 TZlHbucw5EH02z5D8Tf86zI_A2OVaxAShOSG_Pb2yEO2YMbXfngNpDOpCrScui_jBzd70Hs82scE
 CoGdEMju1qgIQps383cSLDBZojlnhe.1LJUgH6rP2LZ9B25t.CTdpLqlr5Wm0C85QN72j68GGpfj
 sw.uIyCaFsOXtCgOOrLF1xY18WUNaRZsVAzIWjVETFSLgDULrPYHpe_n0hLe3fzv8l826a5cis1v
 kaP9I1ADqkU4FKQacZ6YqKwd5S82.OzCFs51TkGsUHcwdLOg1H8ba9CAEcFsfBZs3FroPiUk739.
 Mcka8Mw0.C2iyKThesfuvlN83l2zZ13BDcir_9j_.7FYoJuiw0_21TZlCgPVkbr170pZZSLazl5C
 vDolof.htMMvFVo78Y6hD4dpWT9.URUprNRDm.A4hfzzqyPylkst9kMz3SOhuxWgg2btO74vA4Rk
 Xsi7yXPtiH_uXqy2RHcaVuOmy1iCpOEngAJS7MxbglSrfV3tXqmsSRsQGaFRtPyesHqqRxeX8jHw
 HFk3Wp.PoIf1lkrxtiALXcvwIJ_kP0VscF4Kat_nR_QsUlHERX9g7rxqP6i9zUpyrfoOrKMajHci
 e17rKbogZiKarD8KTdHAeqImlBGgUIcgjbDcbE.ccXUQEezp00J9XKx8ZHkddASt8j1zcMIRmRrd
 QOGz7j603.Wvnb1vDqzdaSxIGxVpWgn63kV7U0Y.rFEAHnVtFB0QHyz6WLwJiLJiAkOCSzUIMIOK
 nA69HRGOAf44EtTNB99U2KES1nY1o2FcEDiCmSSgttflm7igeBA0Gv7JarLmlbdadp4p4EdxgGEQ
 1wMDBxkumh6LHdXA0yo0P9X3V4oeFT2bXRFmFR1NSUTIZSVTMKOE8abVw3dL9gXGOhS0.Y8yDY_Y
 Il1t.0gKVddIjcIxeNZGW3Jm04mCeXQLFHECDvdXzbo9_mn5_J4psA0Yn6sGC3Jwo.eKe63C8vLk
 FIaR.oF.oyV1KEdpfjT.EI6Y6iaiJi5SAeObP0QV0E61ItGbWD6GDoGJMf_j0gN.ouiFWiLyKCtI
 RrHKHYrsBFRV5l5Q6W6Thp62Rgxe1D7trR4F0cohKpEoi9Gqygi0UG8Gro4hgLz86YKILsPSy1LH
 7KSlDmRMBVaqLSyTMO5N6aDDdS1hblNAKB6nsXx.Pz7Bwrv0skvRzJ5t9upU3z1DvjXjI5A6T7dV
 .6Nr1mlBwGvjOo.tWCu_QVoSXJfaLBC7uoYiycvmZa_nWs7ykA4mv0fd7mzAYt7BfYfQn0F9Fuqa
 x3d6ChVOBoTz3Rdp9ruSOIOhpHafAZQ.K1mF5DKb2o2NuXP1opOnf5O09bLqwyecWah6HkBTsq5d
 DE21_zakkt9LGiCqcpsN2HM3tNEBxpckUWv1E.ZLlj87CFRm1Rp8d6OxPKuH4n3hgFc9rzswpaMx
 aD6D2rN9n8NkgzSomO_vKxQtW2qh1go0ahb7LTzQTGqRTC8n_GR8.ov5_2aOQxTiWhAbacKvEdu5
 vLaSwbNidzoOrQxgkEZGAB1qh1.4FCdcNl6TwhADIF9vaD15AqXW0LAzbWO3Hm37oVdPMW09Pguu
 3kaleLS6LNfXNWFyCVrDb6iXltiHwMOXyLbAS5oQm3XafjGo0vzsysY6_AdJBRzLuPGHyr8kNPHv
 M
X-Sonic-MF: <s.egbert@sbcglobal.net>
X-Sonic-ID: 37a32df0-6d4b-4df0-b995-f2dbb6a97d15
Received: from sonic.gate.mail.ne1.yahoo.com by sonic310.consmr.mail.ne1.yahoo.com with HTTP; Sat, 12 Jul 2025 16:56:08 +0000
Received: by hermes--production-ne1-9495dc4d7-mkkkk (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 22744c3e5adef0ff72a49565253faac8;
          Sat, 12 Jul 2025 16:56:07 +0000 (UTC)
Message-ID: <4f530367-669d-41c6-84d9-772aacbbd9d3@sbcglobal.net>
Date: Sat, 12 Jul 2025 11:56:06 -0500
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: netfilter-devel@vger.kernel.org
From: S Egbert <s.egbert@sbcglobal.net>
Subject: Who's focused on dynamic 'nft' autocomplete?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
References: <4f530367-669d-41c6-84d9-772aacbbd9d3.ref@sbcglobal.net>
X-Mailer: WebService/1.1.24149 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo

I included a railroad diagram of Netfilter (nftables) 'nft' CLI terminal 
program in mouse-click navigable PDF format:

     https://egbert.net/images/nftables-railroad-chart.xhtml.pdf

Using latest:

      libnftnl v1.2.9
      nftables v1.1.3

I am curious with regard to CLI auto-completion, where do we stand with 
the <TAB><TAB> to pull up a list of table names and choose from?

There are other dynamic/multi-context/multi-token fields such as (broken 
down by functional group for easier multi-state machine modularization:


     Identifier Group
       table_spec/identifier (including 'last')
       chain_spec/identifier (including 'last')
       family_spec (ip/ip6/inet/netdev/arp/bridge), family_spec_explicit
       set_spec/identifier, also set_identifier
       map_spec/identifier, also map_identifier
       flowtable_spec/identifier
       xt_stmt/<STRING>
       set_ref_symbol_expr/'at'/identifier
       meta_key

     Stateful Group
       counter
       limit
       quota
       connlimit
       last

     Dynamic Group
       variable ('$', defined)
       objref_
       tableid_spec/'handle'/<NUM>
       chainid_spec/'handle'/<NUM>
       setid_spec/'handle'/'NUM'
       flowtableid_spec/'handle'/<NUM>
       rule/index_spec/<NUM>
       rule/handle_spec/<NUM>
       rule/position_spec/<NUM>
       service names (port label, /etc/services?)
       jump/goto
       log level (severity)
       log flag (facility)
       time_unit (second/min/hour/day/week)
       icmp type
       icmp6 type
       icmpx type
       mss (well-known?)
       wscale (well-known?)



For 'nft' CLI, I've identified over 1,412 edge-state transition, 240 
states, consolidated into 27 groups that could be used to auto-fill any 
dynamic content on the CLI prompt.  Last worked on Bison for gdb-c, lua, 
GNU c, nmap, and Bind named configuration file syntax (1,082 edge-states).

But ... readline() is relatively new to me, CLI prompt processing 
(notably Cisco) is not.

I've scaled my prototypes of readline() for 3 separate groups of state 
machines, including the master edge-state (where it goes from one token 
to another).  Just to be clear, I am not seeing this same capability in 
other "readline" substitution libraries ...

In ChatGPT perusing of MARC.INFO netfilter-devel mailing list, only 
Pablo Ayuso worked on 'libedit'.  I hope he shed some brief wisdom for 
this development route as I further study these syntactical requirements 
of 'nft' CLI and small prototypings.

I do do have my Python program, that given a 'nft' Bison symbol, can 
identify what the next available token directly derived from the 
bison_parser.c file: did this by leveraging Bison EBNF outputter, EBNF 
parser, EBNF->NFT parser, and then examining each AND/OR/concat logic 
for its available next token.  Due to lack of response, I'll wait until 
a request is made before posting this code to GitLab.


Cheers,

S. Egbert
