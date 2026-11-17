Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.228
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794909290;
	b=yf55/OeayvvX4dORvN6WvRueETX0CSGnPYCvbecPHv5Q7oAypg/LPfw/K/v1asod5wuH
	 fQbByYIhzfSToAGqDL9VyIJwRqqM/bOuGz4KsXdyCUC/g1TKpBYqHq6sX3lc5BhMT+JD4
	 Lrp7lwt3gKpo87FYQIuI/dl4jcVglEBMKWyPW9VkiCCs/h2KJDBcwS5ezFGmSwY/Zydko
	 VgCUqo6rbH/AEjs88BqUX7WPJouMa4Cvspg6U6tpNoPklDrM0dH5B6wg3pQ8WX4dj5rsv
	 Q1AyOMK7K4Do+R2rzWtArgCpiblBLqTaOYOJXvyYUCewyl+WbDv/ibofOVboUJLs9WQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794909290;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 To:Cc:References:Subject:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=HY7hm2LGrarvL7vCkTx+R6XyYR3bMHbN09qK3a0QZxY=;
	b=xYqHIiha35mB0YI2RU3v05grmYlyDXHM40x+XbusL+3Qyud7wbkc/hhQm1L+QmbtFLWZ
	 9BoJI76lN1XmBFoT6FSrwmGiX4YLpDX84sWa05iFlTkINJMnLvG2nBTLgoFvlGwaCmgvH
	 47L/LNK05xP1L+7p3rApEHPsWzqcQ/A6dJ6+M5OUntATKNf0jM5A9jnIAJlSbvBWsgNYH
	 +Df8b7CC/KXvAEoSWAKG+DKxT4rCb36RJQdWJxJckh6i2H8w4EkijE5/0f67MrACx/Hvk
	 GncT1Ka0GdadmkHqlzT95zCq+vwyPDl1u6rX2vRy2pmg7YOWAVjcAYjf4PcLIWIX5bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=mm+NpWGr;
	arc=none smtp.remote-ip=95.215.58.228
Received: from mta1.migadu.com (out-228.mta1.migadu.com [95.215.58.228])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541A4606A331
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 09:54:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 541A4606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=mm+NpWGr
X-Envelope-To: netfilter-devel@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=HY7hm2LGrarvL7vCkTx+R6XyYR3bMHbN09qK3a0QZxY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794909287; v=1; x=1795514087;
 b=mm+NpWGrii0ekDTKlxtxBNCjvZaWXaOBCl1HOwiHszB3nvPjxdP/fSpnzwFpT5kNskQjP/kr
 7BeX3Cly8Tu9bbp3V3QgxYMu6O+jPTFUrjukFIskqUt/ODrNdcR4sDL6leBVz7M9W3oL66YRDx8
 +VHAwpJtMitSb7CqwVZyQtpA=
X-Envelope-To: netfilter-devel@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id aeb05d9630cd1bfe;
	Tue, 17 Nov 2026 09:54:47 +0000
X-Mizu-Trace-ID: aeb05d9630cd1bfe
X-Migadu-Flow: FLOW_OUT
Message-ID: <5a07e667-d217-45b2-a340-bf762a91c286@linux.dev>
Date: Tue, 17 Nov 2026 17:54:39 +0800
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: jiayuan.chen@linux.dev
Cc: netfilter-devel@vger.kernel.org
References: <20261115150342.86521-3-jiayuan.chen@linux.dev>
Subject: Re: [PATCH nf-next v2 3/3] netfilter: bridge: annotate data-races
 around br_netfilter and nf_log sysctls
From: Jiayuan Chen <jiayuan.chen@linux.dev>
In-Reply-To: <20261115150342.86521-3-jiayuan.chen@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Sashiko reported an issue but I think it is just a pre-existing issue and is not introduced by this commit


https://sashiko.dev/#/patchset/20261115150342.86521-1-jiayuan.chen%40linux.dev

