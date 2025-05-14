Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 801912376FD
	for <netfilter-devel@vger.kernel.org>; Wed, 14 May 2025 11:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.212.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747223688; cv=none; b=HmnTNZ05WGbYEqHE+UmCjUyT3czeAXiWeDhTc5tAOjJLviCpD1yei53+3R1EKhWqMmZtwDTsEvHY/zlpm+i6K/hLUX8u601itrZp8yJ1KUuARgfUJqScK5AvprJM2HBqlG0H2Ab3C2OWF9h726EyLn1Awxy7sbRLyPfflcRUQSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747223688; c=relaxed/simple;
	bh=cNtX+U6YbswppRgAV/s3/3JTkkP9PZ+H+LwRBk7YSKs=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=eLNvgRfwecWbGxbgSwmgcaOt57RTaeIpTccT+pTSfUM1O46ejZHIjVljO3ScWgryX0nJSSp0hmFVQzsAHlR8VWi00AFiRrbhZoX2ouhsGguvqQnr3i4Gsv8VUPYkKSkWtKA1cniVUivx4gR4qxF7iF+jhisHfSYzMR96XqR1wCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de; spf=pass smtp.mailfrom=inai.de; arc=none smtp.client-ip=144.76.212.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 25121)
	id D21061003F05EF; Wed, 14 May 2025 13:47:55 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id D1C6B1100AB400;
	Wed, 14 May 2025 13:47:55 +0200 (CEST)
Date: Wed, 14 May 2025 13:47:55 +0200 (CEST)
From: Jan Engelhardt <ej@inai.de>
To: Sunny73Cr <Sunny73Cr@protonmail.com>
cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: libmnl name definition
In-Reply-To: <IShfT8BT5atzrguXzEkqxTG6-2a6ZsduAwhPXz47h4Rtcp8eaJZhPdg1QZx0mjKWb1UXvGINZSv7wjqoxnb4lDLuH_V4GxXAoGtPAhrEqM8=@protonmail.com>
Message-ID: <10r9226q-3nr5-00s2-n155-153nq0r538nq@vanv.qr>
References: <IShfT8BT5atzrguXzEkqxTG6-2a6ZsduAwhPXz47h4Rtcp8eaJZhPdg1QZx0mjKWb1UXvGINZSv7wjqoxnb4lDLuH_V4GxXAoGtPAhrEqM8=@protonmail.com>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Wednesday 2025-05-14 13:04, Sunny73Cr wrote:

>Hi mailing list,
>
>What is the definition of 'libmnl'?

https://www.netfilter.org/projects/libmnl/index.html
