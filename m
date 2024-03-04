Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C72EB17C62
	for <netfilter-devel@vger.kernel.org>; Mon,  4 Mar 2024 12:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709556435; cv=none; b=l/arxGXG7N9N2qW3jBumyqbIpiMC+9lWkUCDzdeWpIPP8Pv8PDfVrVLk3eeE/y6eVhrul8t7802gJwQ3rtrs+OjSts1Z+hN2ahfIwzQ3IIoEYA0gzcSLegFK28tMWaPmNPaCnsgavu6hzsS9LdmG6eHvyKpF6J64T9NG2/u0A88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709556435; c=relaxed/simple;
	bh=i8PRd8EkvjxlUffwzVywJsRYl12D8Sr9qoNRveRBwmE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jSzLjn0uj4NQIr2RZEPzXtiLGbV+NJYKGwzpRSEVgw/NHiOzCS0Gudpz4letjLgXKDolnZ/kpKDq48M2May3IZo2GhOs5q8xHux1IXtsUnY+QW+lhv9MMWdkH3ZNXvFm0kVsBU3XRU/NW92JAVm01akB/zi6z4+mdpQIYwqPFZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.33.11] (port=43812 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rh7XE-00CEbH-QL; Mon, 04 Mar 2024 13:35:14 +0100
Date: Mon, 4 Mar 2024 13:35:11 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Donald Yandt <donald.yandt@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH conntrack-tools 2/3] conntrackd: use size_t for element
 indices
Message-ID: <ZeW__zJ0C-JJdSBw@calendula>
References: <20240301170731.21657-1-donald.yandt@gmail.com>
 <20240301170731.21657-3-donald.yandt@gmail.com>
 <ZeL3HJRhC3D8yMlR@calendula>
 <CADm=fg=TbKc8D-nzY7kA=NT7Fi_ZJ7ZLA3uJB-7+bK2-s5W3FQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADm=fg=TbKc8D-nzY7kA=NT7Fi_ZJ7ZLA3uJB-7+bK2-s5W3FQ@mail.gmail.com>
X-Spam-Score: -1.9 (-)

On Sat, Mar 02, 2024 at 11:20:38AM -0500, Donald Yandt wrote:
> On Sat, Mar 2, 2024 at 4:53 AM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >
> > Hi,
> >
> > Could you describe why these are needed?
> >
> > Thanks!
> >
> 
> Hi Pablo,
> 
> I mentioned it briefly in the cover letter and explained why it should
> be used in the commit message for version 2.
> If you require any additional detail, please let me know.

Cover letter gets lost when applying patches.

Split descriptions into each individual commit, it really helps us.

Thanks a lot
