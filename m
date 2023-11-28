Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cp6S03Pp"
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12CD71A1;
	Mon, 27 Nov 2023 20:30:00 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id 4fb4d7f45d1cf-54afdbdb7d2so4741532a12.3;
        Mon, 27 Nov 2023 20:29:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701145798; x=1701750598; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=e8KRWz2Kig8DZydBY6sQt8MlKK8crA4v1g4vQbuYdQ8=;
        b=Cp6S03PpnSV6WI4Io/a0b9LlwdPOUmytJ8m6A0YjBRMGJOlQC2Xh6Vd7cOTzj1QDYN
         Zg0SsFfSE7UB6ipURKuHfWFvO/gttrFusYwh2M6gxXLn2UvUXM8YPH4ogdperRYU+9GF
         2RtH6tuiXrP9druzdcCqrh1SiL9ysa+Gz8GPJ/xYCWS1KxbiJR6tUtxtweXzjT1BmOb+
         cZzKPMdCm84N1fx/04VNtzaSoDDnkiENA34xS7vcV6VAs230mw8pdXlAxY0zRVXYpG3D
         w4cgA8aG0ZQYWcyptemkuwURFHyqE0yDYwfc68qmDE3m8lPUrt5fxhnWmAXwC8sAQE9o
         8aPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701145798; x=1701750598;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=e8KRWz2Kig8DZydBY6sQt8MlKK8crA4v1g4vQbuYdQ8=;
        b=hXIcTty/hkxE83x2URCLZO40FoZ98uw+IETF6clUx2ZNeYRfj5v1dJgoELOrNjl1f+
         KBRp3hFuRNM6WWtCx5lPlKb6MVn4prTB5hUH7KMIIy1r3titiuuHdlhM+FUHpuMYdO10
         gQ7L6suySSF4RWPSaREH87yGL1m+jPaGOAXGguwWX3fuwjopFUlaE2h4BlZemsRNNUTJ
         EWhvPRs9yaH9VZf30ImEB1Cd/ysgvQESZ4DG/yYnOWo6gdtdcUEsFo4/K97sBZe48DhH
         zK3fMPVBF/TPkLo8UpjkuuEHcGSapzsj5rxh3enlQ7bY/f75Qa8WBwd1lTwlS9UKjmRO
         wpMg==
X-Gm-Message-State: AOJu0YyKmH4Hi43OYl2svLdX3z4qgkj9NPXQ36RA0Lgqf5/DCJ+PeIQT
	nqeCN53R8s+572lbOKpZOCIWMQtC//EWI1iVB9Y=
X-Google-Smtp-Source: AGHT+IEWCOb1hpXMkkdVf/pGRKpsM5aDSSTvq0QZHmVaxcISI5j2gWsQF5bAGiKqa0kqhJFZ+PADFTv53awM2mBmmoY=
X-Received: by 2002:a17:906:c9d3:b0:9e0:2319:16d4 with SMTP id
 hk19-20020a170906c9d300b009e0231916d4mr10187560ejb.40.1701145798060; Mon, 27
 Nov 2023 20:29:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: =?UTF-8?B?0JzQsNGA0Log0JrQvtGA0LXQvdCx0LXRgNCz?= <socketpair@gmail.com>
Date: Tue, 28 Nov 2023 06:29:46 +0200
Message-ID: <CAEmTpZH5Kt-uBwU9be-UaS1wi-nJtoYAh78UFio_Op7j3CH6jw@mail.gmail.com>
Subject: ipset hash:net,iface - can not add more than 64 interfaces
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>, netfilter@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, kadlecsik.jozsef@wigner.hu, 
	kadlec@sunserv.kfki.hu
Content-Type: text/plain; charset="UTF-8"

for i in `seq 0 70`; do ip link del dummy$i; done;
for i in `seq 0 70`; do ip link add type dummy; done;
for i in `seq 0 70`; do ipset add qwe 0.0.0.0/0,dummy$i; done;

Reveals the problem. Only 64 records can be added, but there are no
obvious restrictions on that. I s it possible to increase the limit ?

-- 
Segmentation fault
