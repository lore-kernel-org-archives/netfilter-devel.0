Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3890F158545;
	Thu, 30 Jan 2025 15:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738249321; cv=none; b=t7RrJZ/jl9gVGQ9Dq/qJPizw1rRr0+Ov8plIDg/H4/KLZrVNSbt5Cmi1WuXzNdMPXcHWCHzHSvugaZLNLz6sKlEHb2mhZ5qeraUe4FQhPHDRXtX5BCpnPKnuwM63EcrLo8EnnHGxP54gbDEazfBgkuqWPnC7JsXTtqM9oJCm6BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738249321; c=relaxed/simple;
	bh=mfCOdbeCX77mBFY/SsE+J1XetqxL5CfcbaLfUlfpX2c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d6dT4WeqD8IE8p8d2vOKHtOmB+1VZyRcofJguTtSJXLX7qi4xsgrHakkjtXJRJOJDvz+L6ggiU3WfKugfPoJjO+aXqCcozJJWpzY+L2q7wq3wYNHhBZHHPsqEMbBW+L+gB+xBoG/K/I7Nu3oQ7xNi9d436sh+x0Wy4T06dzcqNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bkDBHqYy; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bkDBHqYy"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5d3d0205bd5so1275840a12.3;
        Thu, 30 Jan 2025 07:01:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738249318; x=1738854118; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mfCOdbeCX77mBFY/SsE+J1XetqxL5CfcbaLfUlfpX2c=;
        b=bkDBHqYywU9ws0n+QiubYsaL9TxdrpykMIcldWaiCmT5MU4sfz1+X6wnHurqIrrJgb
         JsJkrjQYDrVI24bh9usZHRQ8jXB1IrAF9uw168LmLiIpL1Wugg6cOjeVxi2fnGJ0mmqn
         PARnpzxOwKIxpixmhn23mao7p1KX1se7ZMrtKyfRV1zcCQBoUakbN9kUJ3fHKHamJixC
         DuJWx6MrZCDeDPQTV0dO/B5Nb90XYZ1zlYRR9wmtlf3cbEm+A8s+ix6K8/g9X0VNgXYy
         b3J0bAylPhLhoIkKlGGZnxj7BcXWw7r/8yHCS/N0SHtXCdkaSsyzyskQ2h0FNF6+PZMv
         Y2EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738249318; x=1738854118;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mfCOdbeCX77mBFY/SsE+J1XetqxL5CfcbaLfUlfpX2c=;
        b=DCcxejX4YQmHkGRJe8bZQeJU5qm4s5F9GttQ9Um2GbyWBWBnL+VZZyJnGt3xszpSkN
         PqdXvdOwRwlcBDS8XWigPsNl8/UxMYVn0fkujO6ksuFlbLYYI8Gg5oHFCbqQNbnAc4+V
         FN8FiO3+53gX8duOg68Rc5OUfcnkYyYW5BMGL5q76eT7obbyQbATLPZR5RSimBjzaj7O
         lKSjjj6OKVRGuG4qi48pbXJMZqqLC3bdroaMyY0E6XTiaWMA1tXBIyOOsO3FkTViobR+
         mUhUnBkseCrMvdGFsJfseRbkfoj7IzvuzRPqzOTHVWwXx9k5duPBROuGprDd7IpSSTzk
         2YqA==
X-Forwarded-Encrypted: i=1; AJvYcCV8K5ComH/EmhvxmilqGAq2Io5AMuGRxgSdKywm1a2vyv6o7k/m0LPoiJ2r8ZTQT9yUxYgnOg0=@vger.kernel.org, AJvYcCVIo8wp21gg9GU+fh/YXwd4zI1Jhoyuzq4CXsS5MEFCxqf5/add037pek4hW+HJRzMnjYPQN/5N41ZoSKkafcrU@vger.kernel.org
X-Gm-Message-State: AOJu0YzoRqZovZNdPIteMxd+JioRedsuL0O7JKi4wa8ghTnK9jfn3vkM
	+Un13OWbbGugbBiqeYvTu6/CjztqNqyMxe34CCWj9TGp2EQiC/pfSr+7v+CAS7qyoi76LSWIgc3
	sPfIgVuWrdb8RzWo6y5DQgJmcTx7javYGI+c=
X-Gm-Gg: ASbGncu7m5OSSinK1IE7bP7T66MsCVI6tkgjUZJsjArZH2V2LT64cqOv49H5wtXBMHJ
	91wEPVXNXz+U5C6x1Xi+RNJdmSQpFkZ2afnrUDHlQA9GAetEeCduKhTzw5nRGJCJQDTi0NCc2yw
	==
X-Google-Smtp-Source: AGHT+IFatBDTu/hzuprxAFEvE7bmH+4UNeXTKM7tlE76rgonvSHvrp+thtT3SJEyY91gKAzX/+wQ3duh7w35Ec+lyTM=
X-Received: by 2002:a05:6402:2711:b0:5d3:bc1d:e56d with SMTP id
 4fb4d7f45d1cf-5dc5f01e7famr6541900a12.31.1738249318165; Thu, 30 Jan 2025
 07:01:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250130142037.1945-1-kirjanov@gmail.com>
In-Reply-To: <20250130142037.1945-1-kirjanov@gmail.com>
From: Denis Kirjanov <kirjanov@gmail.com>
Date: Thu, 30 Jan 2025 18:01:45 +0300
X-Gm-Features: AWEUYZk030xIyWlSQIOd8_zd4qI7XJ7QRbWfR325L5LmK5SPMg3xLVE-hBFRzss
Message-ID: <CAHj3AVn0jADTnuLtGtDmr_-+0==8_=ARJ1V+y8iOPU-Yz=6cEQ@mail.gmail.com>
Subject: Re: [PATCH nf-next] netfilter: ip6_tables: replace the loop with xt_entry_foreach
To: pablo@netfilter.org, kadlec@netfilter.org
Cc: davem@davemloft.net, netfilter-devel@vger.kernel.org, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

please ignore
