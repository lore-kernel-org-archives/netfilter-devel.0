Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66019225A27
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Dec 2024 23:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733872475; cv=none; b=nMz7TyjyHz/0XevAmTAysx90MACmJ364ipwuNJDUUySu79ReLxC70EjfhyGzRRFcmP4FR+cTke8OHQhLygqcGH/pRTHI5Pnrpe6ClsA1onxUlo9sAOjpUKq20NLaGh25VOYg5MHyfZNdTBVVgcYQy98syomkPrs84OMErfzvJKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733872475; c=relaxed/simple;
	bh=3x5TXPzh1y9Vn/sDwfrpCvwrmPWEU4Z2YUHlCg/j1L4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Kl2K+zdfHTFU1OsRkiU5UYN8JI7anhxZE5nTd1EdS9KOruOJymQy2Ea26JdM+NokGkpgv821ogfDpUCacMm31v/EVir+ti2z8lixa+n74p75FJCpUfP/XytChUvJqGAd9o36X2q+VUDAosAJZQhb4ouq6RyncWq+HHFSM3mZLFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=lHLPUz2e; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="lHLPUz2e"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BAGATF8012704
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Dec 2024 23:14:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	PS7l0d33ZO6FBTryro+pjfe77l6D5X7/u/fq40BAyts=; b=lHLPUz2eKaNKUox1
	Ub5dhzdNAOoET8wh+maovCNDPMy6t9eby0VQUopQ/MZLa6olLQwy25+UgpQb8ro5
	VlaMWxZAETVnPKvlzO71jszhSUnevwYHdclz20ywMSlVphBPRa3l4C1hylijowi6
	Bk3QIOrIkCQ+2EOFX/Sdw0b2IpZEpF1kH2IJP81FgU3tYlzhsESrVAf/9ob9ocEp
	ghZvyaVc4lOYnIZDKgvxAUu3jssYTEMSXzRSX3MWUGVMwFilQ0CtwOxrY/ufjUY6
	/bXYCyJGZj10oYxR+tKJcKdW/M9cw92yDO1a0dD+j2PcKvi8rQ2zfcQIOo+BmC3o
	GqzWSw==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 43ceett72a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Dec 2024 23:14:30 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-2ee36569f4cso6229639a91.2
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Dec 2024 15:14:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733872469; x=1734477269;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PS7l0d33ZO6FBTryro+pjfe77l6D5X7/u/fq40BAyts=;
        b=I4r9DxJxP1qxpKGHn5cGN+WfUfqVj8n8ElIyXGA4Ohky32iIqIOE6p/pzjEHt+trFZ
         GeVnppFdyRTAhwjBcJNal48vvjriDss84vYUPsXpLfuoGaQ4HWD6J0Qu3O4NV2JBHH8h
         YwWDqU8Xswgx0MXH7ZOzfQqiTuhYnwQn4jQDsPV+47NM9zd15an31wPQvDAH1HwaRdUM
         S98Jp1uzPKKs9McZJ8GT7XPja/PwKGUX+mapNLRIP74O5FaiZtIXiK4xugjNuUeIDRs9
         Y69MdtHMzniqvtquXX38C6t5t4kg84Wwd2NHgwYJsdT9tuJ3wp6d/F7lr4n85A009r8H
         fkIw==
X-Gm-Message-State: AOJu0YyYEL68G8efplD6uqEHZZ8uqwLKB36ND7sfmWZd0EmKZ0NOCiAG
	SEjNlJ/CyMmi04ILXKqgBaJfl5XvcXUSht+2qZQiMq3o0h3WbBZeKQ2PulZt8emBjEf1tWh/UXp
	3zpgaEVnrlX9KodkgUS8/fQsaENYYMaAE4NNHG7RgYQ8jPXYAo2+uC5TnQ6l3S4KWJC4=
X-Gm-Gg: ASbGnctXoL7Lc9fuve2N1ILjlXFTTAwMiMrS9SbkP8+GxR63b0QYEjT8LgfQkYFnFpU
	y3Zc5zO3zwj7zGTvEHf6AjJ0/deGq3RehaZfSbTcQZ+1HUrXmWGEtrXUwy72hl8gEJ8z//b7NbY
	9cBo8CzodR1ZALn+yo7LB9X3cS1msOxfIwOxv9IrYzGhmDLYWpBMZIoyjtJ9Pv/X2V0bbduKqJl
	oSOQ9kh7561XA7WC9zCrhpWkomDKpvxABCDNsgQa/k262/nsE+v3C1rTXUHyEHuIqFh8t2m+mhk
	cgpOGuInu2agQuqd7QrYRTXUaiFjB1KhMgtVh9ehFN04qMA=
X-Received: by 2002:a17:90b:2d81:b0:2ee:dd9b:e402 with SMTP id 98e67ed59e1d1-2f127fc6f84mr1521930a91.12.1733872468891;
        Tue, 10 Dec 2024 15:14:28 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFBBY7t9Ty+FaaMWRfRUoSNUm5Sp5vin1MZzPlySUpMdXEhND47a5JS9XP+rCTHee3d0P0EmA==
X-Received: by 2002:a17:90b:2d81:b0:2ee:dd9b:e402 with SMTP id 98e67ed59e1d1-2f127fc6f84mr1521809a91.12.1733872468344;
        Tue, 10 Dec 2024 15:14:28 -0800 (PST)
Received: from [192.168.1.111] (c-73-202-227-126.hsd1.ca.comcast.net. [73.202.227.126])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ef779bace5sm7621993a91.31.2024.12.10.15.14.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Dec 2024 15:14:27 -0800 (PST)
Message-ID: <315e9178-5b10-4de0-bdcf-7243e0e355bb@oss.qualcomm.com>
Date: Tue, 10 Dec 2024 15:14:22 -0800
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/19] Converge on using secs_to_jiffies()
To: Easwar Hariharan <eahariha@linux.microsoft.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        Julia Lawall <Julia.Lawall@inria.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, Daniel Mack <daniel@zonque.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Russell King
 <linux@armlinux.org.uk>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev
 <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Ofir Bitton <obitton@habana.ai>,
        Oded Gabbay <ogabbay@kernel.org>,
        Lucas De Marchi
 <lucas.demarchi@intel.com>,
        =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
        Jeroen de Borst <jeroendb@google.com>,
        Praveen Kaligineedi <pkaligineedi@google.com>,
        Shailend Chand <shailend@google.com>,
        Andrew Lunn <andrew+netdev@lunn.ch>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        =?UTF-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.com>,
        Jens Axboe <axboe@kernel.dk>, Kalle Valo <kvalo@kernel.org>,
        Jeff Johnson <jjohnson@kernel.org>,
        Catalin Marinas
 <catalin.marinas@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Marcel Holtmann
 <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Fainelli <florian.fainelli@broadcom.com>,
        Ray Jui
 <rjui@broadcom.com>, Scott Branden <sbranden@broadcom.com>,
        Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>,
        Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
        Louis Peens <louis.peens@corigine.com>,
        Michael Ellerman
 <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Naveen N Rao <naveen@kernel.org>,
        Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, cocci@inria.fr,
        linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org,
        dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
        linux-scsi@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-block@vger.kernel.org, linux-wireless@vger.kernel.org,
        ath11k@lists.infradead.org, linux-mm@kvack.org,
        linux-bluetooth@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-rpi-kernel@lists.infradead.org, ceph-devel@vger.kernel.org,
        live-patching@vger.kernel.org, linux-sound@vger.kernel.org,
        oss-drivers@corigine.com, linuxppc-dev@lists.ozlabs.org,
        Anna-Maria Behnsen <anna-maria@linutronix.de>
References: <20241210-converge-secs-to-jiffies-v3-0-ddfefd7e9f2a@linux.microsoft.com>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20241210-converge-secs-to-jiffies-v3-0-ddfefd7e9f2a@linux.microsoft.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: kT1DCfulEavmGU4LSxwGdVRPnSuP7Cg0
X-Proofpoint-ORIG-GUID: kT1DCfulEavmGU4LSxwGdVRPnSuP7Cg0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 spamscore=0 adultscore=0 clxscore=1011 impostorscore=0 mlxlogscore=851
 bulkscore=0 suspectscore=0 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2412100166

On 12/10/2024 2:02 PM, Easwar Hariharan wrote:
> This is a series that follows up on my previous series to introduce
> secs_to_jiffies() and convert a few initial users.[1] In the review for
> that series, Anna-Maria requested converting other users with
> Coccinelle. [2] This is part 1 that converts users of msecs_to_jiffies()
> that use the multiply pattern of either of:
> - msecs_to_jiffies(N*1000), or
> - msecs_to_jiffies(N*MSEC_PER_SEC)
> 
> where N is a constant, to avoid the multiplication.
> 
> The entire conversion is made with Coccinelle in the script added in
> patch 2. Some changes suggested by Coccinelle have been deferred to
> later parts that will address other possible variant patterns.
> 
> CC: Anna-Maria Behnsen <anna-maria@linutronix.de>
> Signed-off-by: Easwar Hariharan <eahariha@linux.microsoft.com>

I have the same question as before: How do you expect these to land?
Do you now have a maintainer who will take all of them?
Or do you want individual maintainers to take the ones applicable to them?

/jeff
