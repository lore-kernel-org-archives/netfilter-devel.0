Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99402171E67
	for <netfilter-devel@vger.kernel.org>; Tue, 30 Apr 2024 16:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714493816; cv=none; b=QfLI82XTXX1KejP17fu4kKFHkKF5aGVJySZF/IFlySBL9+N0V34rVZY9UbCOAUX4PDtwKEtA/npkbtIDLFRe9EKTnbx8r09jspx/AW9mjklecNb0ULlLbq59uDYDRROu6zhdXOG2iW9ZJmMZa3D9jOBZqrqhH9xJUXlDP56PIuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714493816; c=relaxed/simple;
	bh=I9e+TtAC7XyEPgqwnmDbT3MO1dTTyq4da18bEUUmRy4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AIK6cGzUAWiiI9rOqVDageb6zYSUb3PcFcwz3XXMecU/aVCkOLqK071WnnQLBAWW/2571Azts42YBIS94RHOdeiiz0foJSWaewa68yd/06I6pbEMTyNIenMHoMUZ3wBx9ZARXFw8PpNDR6qqA/6gsD8CP+WZ28ugML5V8AE45n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=gi70BU4J; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="gi70BU4J"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=I9e+TtAC7XyEPgqwnmDbT3MO1dTTyq4da18bEUUmRy4=; b=gi70BU4JUBBXTwxWxgv3pICSkQ
	XhhHX2J9mr2FhaeDCJ//HJ74inDoZMTCITeqnVZTMbnsibAdCnvu5r3WKddm/2lttdytY8evhv00D
	Q4BhOURd2xMHeHxlDhFGkyUD9iQI7n9w0e3IWIZ9/2Dh6E9MchpFt9o8gZ8+qo73ubCOVmnBkKvCR
	qh3kPOH8IwKSN2YQHqUwK1Mbi+kml7ooGEJF0qfmE0gGeqZlLlKMKkHuV/5SivHWm+a7iYkL9uO6v
	uujhlyP+bWcO9i/HiSK0AwGSoEV0uDs7U/lzOY6gwG7nohPlOsgEi4zjtNas/Sr7O15aNoKObvYfw
	gY7P+mVQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1s1q9z-0000000050I-1iQ8;
	Tue, 30 Apr 2024 18:16:51 +0200
Date: Tue, 30 Apr 2024 18:16:51 +0200
From: Phil Sutter <phil@nwl.cc>
To: Evgen Bendyak <jman.box@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [libnetfilter_log] fix bug in race condition of calling
 nflog_open from different threads at same time
Message-ID: <ZjEZc1beV1ODFU1j@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Evgen Bendyak <jman.box@gmail.com>, netfilter-devel@vger.kernel.org
References: <CAM9G1EADHBYk9Y-Y9RBHbAhqOPOMab41DOEh+PZZa6XKGm8drA@mail.gmail.com>
 <ZjDN2DNJNmbEv68p@orbyte.nwl.cc>
 <CAM9G1EBn0m6xD1NS+4Gs7Ew-JR1QfQZJrR7xqoA5sHbR542+Bw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM9G1EBn0m6xD1NS+4Gs7Ew-JR1QfQZJrR7xqoA5sHbR542+Bw@mail.gmail.com>

On Tue, Apr 30, 2024 at 04:58:41PM +0300, Evgen Bendyak wrote:
> The patch file in the required format has been attached to the email.

Patch applied after adding your previous mail as description and an SoB
based on your From: address.

Thanks, Phil
