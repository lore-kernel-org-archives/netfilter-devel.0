Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44EA47125A
	for <netfilter-devel@vger.kernel.org>; Sun,  4 Oct 2026 17:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791134685; cv=none; b=B1pfiC1eiQMIy9sr3ie5sHQ6MusFnanOmSbGjAPEH+t/ETBP0ZMxrfMxrKph3eaanEfx1HNd5lihqUsfHOKKXQiHHzaY6Oz0ls0H2cRFsJvBxlOdtbtY+b05BkEuUvu6ehNrnJSYDWm43YfTFarzFnlk6a4YAXMA+9cqmwAyOR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791134685; c=relaxed/simple;
	bh=jfZ8rsHk8indjM0Zk+DYEedBp1/Cz23GDfXWpz6sFXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=akLAKyyYuTyu+Ux+bLjKSeewOX/annlYXnOMPSBCW/Eew/lmgkoDjTOq92r4Xh+ZiYZcWXTVywxXYOwks0XuuXfwRcJRH/rb0MqJfBAkDZWkbXyyPG4xf54rsd3oh1U1nj7RHzbnK+12LuE5hFPTEc5lOC26rcIWUhivJbWTXTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=D4Gs/M0t; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="D4Gs/M0t"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6afbc363efeso944691a12.3
        for <netfilter-devel@vger.kernel.org>; Sun, 04 Oct 2026 10:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1791134682; x=1791739482; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jfZ8rsHk8indjM0Zk+DYEedBp1/Cz23GDfXWpz6sFXE=;
        b=D4Gs/M0tZWtbCiT/UEoislCDMECwgdu68eLLFfevw5ycVYD/lNs/PXaieUjt36cJ99
         mE2Syqqe6RY3N5qnJizN9iCZeOnk8swRuZfgQHnrkDYOI8LmEG4D38FwnH0XVVCt7/BA
         8PrYfo6zrv60OByJ+WyRBlBzTz4nIr03isGaCYjwxtl6AVY20L2y0Z4aj0vhuA3dSI5v
         pxoPtatQt9/55MgsGR1I/fOdyY/eLOTFgZ482QStmOsAX0nUwzCV3FV+CHzXOhJtFcoY
         uuP52I4Rz3TRsP8Sz/gPsgBimShXCltHrKW5Veqku1KurC5NZW4Vpj90h/x6O9GUretW
         yMWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791134682; x=1791739482;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jfZ8rsHk8indjM0Zk+DYEedBp1/Cz23GDfXWpz6sFXE=;
        b=C/MVhoqKahz9uL1MWtJIwu8YeLpTqmKb4QaC0CB/L+se0pUSPbMMr8RkaoAVxM9htl
         p9zfS4WK4XoJ4ZfZb46OvidjxIOAts/ZJJ9mOqzky+6Sh0TYAr7KTHsCWNouL1UjPShO
         1+d2ErA6ZHVv+L5J8scBZ5BVKyR5Q5FE6SLHy2tTH8s1BxQaTtoWmpsm/1pO4ZvkxYRL
         ZmSjDZk4Q4LzDn+y0xICqzymg5aTOIE5gJLfdNm9Z2o4UrK2946WImXHpBWCXyCq4+mk
         5+Fy3EJqJUo3Fse+mGeDrupVqsJXpqJF//jbVNInny0LW3vpnyT8BpEMUWsHSbAF4E9P
         3jFA==
X-Gm-Message-State: AFuF++mQx2tmzo9kmVGOVnTgUak5/5CgVD7KKZr1CnHJ0TzRNj56Wgu3
	Ns6WNKe1iHAKAQ1ATMBpCv4vCmRvukBFOgMF5xUuZkwzqViPndhq4PExqN1EuzfXWCzfle6GnQJ
	kFbdzJw==
X-Gm-Gg: AYBFou0O0SuECTxqgIL20DkYJHo88/Y3BBoxspAuWMh++8DJRipUVGPlj5hXcPtzTZl
	xiuiOXHzaTSBwj+Lq6kGU1r/1gOYmzaXNOnrXBWyeS6Y2sCW10n8DiRPbyqqU8crU1tKBMNncGs
	ejSsLxojOL2F8tCPZt4RJbD8Pc7h2GwD4a1wUIu0NWszL2tGVdibzEqyFvUJHqSbCfMxN8Yv48G
	PQWnwF7w4bzWmz0tex0/QeSC3R9ZNWYwuJ7VtH1wwRlManHVEvcNPYjCBq6DDVEj1GeDZbU30pm
	+ilejlbkWPl+dhmkqaKGcVk5oSJaodXJgfT2VOdRpNypFRB6O/adJ+h7CV4Ze0mDTwB9pxRAf4a
	w9XO1yKlsqFfQQF62ONA8UHMU2K9kE0ASpLGpx0HIJr6V5Ll0Gr6MEWk4LsCsWdOpKisIossOmk
	deQDo5bHXXbz/xID7srQIx1Wgq1REXNMIQvVtxufv7pYaRjx+dGI6aqS/KybyKHO3cxU5XtvzUM
	m0wRzF6Bc1zhqfs8hOZn0K3cfeIze/g12S/Qy4dVS8UK3/DrrsBsD1ZbUjaG0ZdpC33IvcEJrdD
	yO/37dNpRQPWj5bQrPvXwZAObhsrr30I2QMd1vJzaz2MHXweRxmqycsuxOa9uAyWGndvppzKiC0
	/90WW1MihaC7ikl7wOEkx1oYWM/tHupspNUu4n9HC/AXrDyv09sipLKWm++I8tBRnWPG/om5TY2
	T2yJ91rks=
X-Received: by 2002:a17:906:f592:b0:c2e:4474:8737 with SMTP id a640c23a62f3a-c2e6ebfd138mr440395266b.6.1791134682255;
        Sun, 04 Oct 2026 10:24:42 -0700 (PDT)
Received: from Desktop.fritz.box ([202.71.144.189])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2e4cfa6645sm316564766b.73.2026.10.04.10.24.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 10:24:41 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	saeedm@nvidia.com,
	tariqt@nvidia.com,
	mbloch@nvidia.com
Subject: Re: [PATCH nf v2 0/2] netfilter: flowtable: correct and advertise the vlan match
Date: Sun,  4 Oct 2026 19:24:39 +0200
Message-ID: <20261004172439.3548490-1-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260913104251.648421-1-julius@bairaktaris.de>
References: <20260913104251.648421-1-julius@bairaktaris.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Pablo,

friendly ping on this series.
