Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com [209.85.219.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB82241C8B
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Mar 2025 14:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741877757; cv=none; b=Lx/6S4qUwbeQXPlPIXchagtR8ALxKTwBLl45IjnGBPRgX3T1RlFjxaERd4F/M4X1g2/gnUThZBe/m3OKs3ubsytA7M1Jixojh3HSyxhj0k+XwGZcB7/U+S3CvZ5ya2GoHv5IwoSow4yfEFEh9wfPUlZeK0LMi4AxJEZL5vG7ICM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741877757; c=relaxed/simple;
	bh=YJuKLA9fZs5um2dlt794Ut6sg3YJDGUzRGKus1IZgmw=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=MVykP5OKjtqzr6l6xWlv53MRqmQzL2klzu8ur6mFJBEEqPm+ffPOezxtGRzWWsgrwDJXZKB2VEPaR7EaDw2L1DIV85ZN7jaE/j6RF+yjYnc89FxHpqSvSn++MbG0A8PGGrY4lE1oIklvPtM+Ml03dc6/A4P55cHfuKTiTGOkMEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MkvhrgIP; arc=none smtp.client-ip=209.85.219.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MkvhrgIP"
Received: by mail-yb1-f178.google.com with SMTP id 3f1490d57ef6-e549be93d5eso962474276.1
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Mar 2025 07:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741877755; x=1742482555; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YJuKLA9fZs5um2dlt794Ut6sg3YJDGUzRGKus1IZgmw=;
        b=MkvhrgIP/xFkwBJzIvsIfpQnWwbarE4vTpFPkccknUgdwDASLU9MnpVmSUgoeS5GLK
         RcFZowKZAHWR4soRq30+8hkSTdSaA0Q5vVS5QRwx7xdP6vId0FyJic0HpJu2M5vp+kjF
         9fwX3nzIIlmWu2h+cqu/DLjcSRhBZ9EErUq89qdDOQhfP+iStIkVtRUeNbY5cM43cMJo
         9zwQiC+XqZLQvRpvTR6hLbPwh4IiFt1+SU91myJauMU+k7Up5ZYyr3wvtUs751vYGULg
         XBnEnJqHLE+DYmHe9DUSWfE4QsEpwntIjlsbzK3hzZiL3gLOh85oTztngaGkCznHlrDP
         UEsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741877755; x=1742482555;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YJuKLA9fZs5um2dlt794Ut6sg3YJDGUzRGKus1IZgmw=;
        b=vdc7qHqrBJ4SDP7fAsYf2l+6eVGPBM+NRu+DvRT9GaYEKri7TP+jdQMhh/9Ocq+hT8
         vnamO0XQQAsZqbyeGQR/waAWh+doautLEBKGIRAFFE+A9sQ/EToyePq4Pw8cQe8dwEr9
         9Mz0bLkvPMzlCUgIZsSuysclODjB7fMfig02Rm+mNF0cQ1OBgJZxrnplOW3zYIJg/oJT
         u8FtJ3yxLrF0YF9omwML368P/4T6e8STSRftO9a/RyGrwWs6ChAMvpb1k3AB1H9i5s9z
         TcIJkjZwYsnD0Ma6Py+r11z31aJCvtMOjjjRqcip5rv4dEP0Vb/OXSSHOba3EjUOyL9I
         GCig==
X-Gm-Message-State: AOJu0YyopsSn3fHzqw1UwXO/6OuUIq8WaAfSi7YZ8teTk4NuA9gC3EGy
	lyxEySAj1mVUCoyV3/JZcW6fqhmGaLrYnpMiffbW/GUc5vuG7VBc852YxTOzaugRmIkSmDLq52x
	U4K6cUElP0QzzS9rNIq52RJa842D7QSEJtU4=
X-Gm-Gg: ASbGncuWuKuzloIA6+sPin94JI3I7eSaQT/T2jyLnvDheRN9r7xi6eg16xOPh32N24t
	LnMcOy7V+GR1tzLFjdFokPZjp/geWntKYo+n7nkPoARRy5K01W02TiFgsGJzojO1vaEpvWG1/qu
	znbTMpcS8L2ef8OqxIY88Skg==
X-Google-Smtp-Source: AGHT+IG/kiMBRtnPVswHqrReTGPKANGq8dFOQgu/L1ICFUF8xPXjlBjqMt+qDbv7vaGbU8juJFIMiU9gLE41ezBsIms=
X-Received: by 2002:a05:6902:2404:b0:e60:a6a0:f5b4 with SMTP id
 3f1490d57ef6-e635c0f8065mr37450968276.9.1741877754877; Thu, 13 Mar 2025
 07:55:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: =?UTF-8?B?0JXQs9C+0YAg0JHRg9C00Y7QutC40L0=?= <zhora.budyukin111@gmail.com>
Date: Thu, 13 Mar 2025 17:55:44 +0300
X-Gm-Features: AQ5f1Jp7tQg8AQ_kLmHIKqrPIXuapFKriyPMvbrug8xg6JfCmEvDq-InFvSE0ug
Message-ID: <CAAv0m29bukaAnKkM=ht2vPA=0_8Fii24aSTj4MMcXTW5kNJJkA@mail.gmail.com>
Subject: Minor memory leak at iptables/nft.c
To: netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Greetings!

I'd like to propose a patch fixing a minor memory leak found with a
static analyzer. It can be found at __add_target and __add_match
functions, where info is callocated as a buffer and not freed
afterwards. This bug can be fixed by adding free() in both functions.
Please inform me if there is a proper way for me to submit this patch
to the upstream.

Best regards,
Egor Budyukin.
