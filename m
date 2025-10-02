Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC2230B522
	for <netfilter-devel@vger.kernel.org>; Thu,  2 Oct 2025 10:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759401707; cv=none; b=Y/8Zwys9AQTfXIz2DmYXDy0hVQSSxqcAwW4Ps9AisTkHr4BBJ96t+Y59cSiC9GmETIrIENHglYby00uI6WPxD6rFXv9vQ0Etg80Xag/NVIAraqkwep4o97cbkxY4EH3CsqBLKS/gknBrW3PYDI+Xte0SFxhD3iqnaziQZRWFKXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759401707; c=relaxed/simple;
	bh=GBB3MweM2y0FiQUvyPP+jasw0WO+a4fpN9rrJ489bcI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a8fLw+UlLDNDjKfulO3GmN8WZ9Z2Q6b02KIPy+LZyFGtS7BPzHomk5WVl0l6qb0NrTlkcIZ/rw/eyDksgUlit/onoYHOh/svucKMB3s7P+ijsI2tgaFvSiDWdJc7Fhv3vfSfnVrcBVR9JhVZ8r/oGsJRaW2unzU1Md9ELYZtQTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b7IBblZJ; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b7IBblZJ"
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-42e2c336adcso1527425ab.1
        for <netfilter-devel@vger.kernel.org>; Thu, 02 Oct 2025 03:41:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759401705; x=1760006505; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GBB3MweM2y0FiQUvyPP+jasw0WO+a4fpN9rrJ489bcI=;
        b=b7IBblZJXQEEL8Ze1g4eb7d8y92EsgyvJ3m4VWHAy/B56Le1LKchdELRwoNOloivzi
         Cenkbt8SwKpVxmTPAYXNoKHHXrWPIMYt0b3tKlqvQrSJfM5F5WWo22hrV7S0ePf4L50R
         BiJ6XZfE1LRyrGKFJmy9c+Spme+gUf0+sDd0Wq6G65UX4JtF5kmZuE7jsPklspbgl9ZN
         NCdPddLYECr7an/0guQEJotOIPr8DQLDJQ3KYgB9xC0NzE9d9F1dg7ac+7qdM5wdHiGC
         a/WiynxQT/GEKpUGFXm7C6dZGxK0jzqz0Ku2QjJMju8tTpOchbVQ/tDY/9No1ynMqBi1
         hOEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759401705; x=1760006505;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GBB3MweM2y0FiQUvyPP+jasw0WO+a4fpN9rrJ489bcI=;
        b=QiMn7iV5xLFTbnixVQ7w9ZtjV+HKQmSreedZR6eHkYlwrS3oJU9ebYbRmrccdZeOrw
         lYiBT7ZyYDU4+WKKmItFLPCDTIyRwnL7eOyGnU90R7Rsz3ecYZ4G8U0NCJmCJN73tGGh
         FXu8Br4Vre774bD1bAh7eofhQEBB/39pUA68n2XjWTuxw+2HFn+A5e3Z3PyrEjEADoiH
         KluXnaRSEWfW/KMccQr3Sps4fxGaz7nmJ7JXKdCNJuKTXhvSMRRCn+u5ndpbvX0yPG8T
         aXQzCNXSBvCfy0F7FCdWaHZwy0cu0vmmbPcgXk4VQhGSwoyLZwcEM0hHHZoQ81pfzMam
         ZX1A==
X-Gm-Message-State: AOJu0Yw21pHklgCpIMXLNMW2f0moObqfek2n+sc5JRHDk9EmWxE+bJ4b
	cuvIfA7zwJP3wmio/BzL1fSthmg/10MzIcXr676g1dpt6iwSAwL4yPV2o8G0bCP7FLlZdNwID/e
	eP28k6gdLqb6VxCf3P1zvP6Ovtum/Zu0=
X-Gm-Gg: ASbGncvbOv67nUUmtnH1yUMDCITl1fxnDf4lfT03It8ngMSjkQXQYeECYYF9fx6D697
	Jj0Q4eL3eSJ0MzY7vdsmADVMScZGQciag2JsSKhUYtlk5f5ycgduIeBIJVdmt1pf+IS8Fguo8OP
	gZtFs3qX4xMIFDXpbTOnlt44tvky3qyJ8Ul9Txjm99/rzf7huzENyn/ic1YbF7XXHe/YDpyZK7+
	wlGbq2V5jRHCIrYvcDezvfWS9l2E9voLP745lC48BcSNIkaYy4/4zBF+QrCIExaTZfzHDjfsa+s
	l50S8PArVd2xEMTkEFWWvN75JefC+N0MuDwmOgYOmTKDj/o=
X-Google-Smtp-Source: AGHT+IEaVvjCXd6q4+Atbb14Lru69Zwm4qzshbdz0dV+nweE0G41GvhLyfom6Qjx6WhqmF2N+rTrlmLZUEW/ec5b3Cw=
X-Received: by 2002:a05:6e02:1787:b0:425:8857:6e3c with SMTP id
 e9e14a558f8ab-42d81612c21mr87659605ab.11.1759401704975; Thu, 02 Oct 2025
 03:41:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251001211503.2120993-1-nickgarlis@gmail.com> <4814384f-5fe2-491d-9424-7a0aebbbda1d@suse.de>
In-Reply-To: <4814384f-5fe2-491d-9424-7a0aebbbda1d@suse.de>
From: Nikolaos Gkarlis <nickgarlis@gmail.com>
Date: Thu, 2 Oct 2025 12:41:34 +0200
X-Gm-Features: AS18NWDoBYSDpkAPiXUrJTv0HdqqtrheW80itS72DfdrXfI73PdltxUFeL866gM
Message-ID: <CA+jwDRkBHxwz7xHUAdYi1OZ9mtEski4VJ=gtyByritjRAiStmQ@mail.gmail.com>
Subject: Re: [PATCH] netfilter: nfnetlink: always ACK batch end if requested
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, fw@strlen.de
Content-Type: text/plain; charset="UTF-8"

Fernando Fernandez Mancera <fmancera@suse.de> wrote:

> e.g for a batch formatted like (BATCH_BEGIN|NFT_MSG_NEWRULE + NLM_F_ACK)
> - nfnetlink would send two ACKs while it should be only one. Granted it
> won't configure anything but it would be still misleading.
>
> What about this?
>

Thanks ! I was a bit unsure on whether the status should also be checked.
This seems to work with my test.
