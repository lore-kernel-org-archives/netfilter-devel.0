Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CC551D0E28
	for <netfilter-devel@vger.kernel.org>; Mon, 13 Jan 2025 22:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736807042; cv=none; b=pmWF+XEtMBE7otTiFh1QRwL8xpQjZn7w22Msqi1u05ZW9IfcGqriVYfuPhWT8+cghr2gEZk+RBuIw0eySY9TduYFlD/eW0OtgB/c3WYTk4/ONGSbAod+3bDMJMI1FzPv1yLXyPd7r3Zh/2CZkahB2UZAzPaf0GUejFZYMzexYL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736807042; c=relaxed/simple;
	bh=qnY/oU5l7qf0bluW0LbKa6jTCpyk3/ncPYMAD9MBqzE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U+6rvs8XLd9/7lJiNmsIkW8xbcqo704nvnGguXlf90ZlZitrAd8eINBWQQhQftgkfOd4MfLD9uH2hqM2BOVfB2qFWY+VRdIPo4Yvzh6U6gVK1zEXSc2FbaLTJ7VaZuocuVBgHoQEY7IKkQ/ApockWseLJVMJJFkCS/m02AlKMn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Mon, 13 Jan 2025 23:23:55 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: James Dingwall <james@dingwall.me.uk>
Cc: netfilter-devel@vger.kernel.org
Subject: bugzilla forbiden issue [was Re: ulogd: out of bounds array access
 in ulogd_filter_HWHDR]
Message-ID: <Z4WSe2kF_FGbOJp4@calendula>
References: <Z4Tr5p19Uoc1UEcg@dingwall.me.uk>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z4Tr5p19Uoc1UEcg@dingwall.me.uk>

Hi,

On Mon, Jan 13, 2025 at 10:33:10AM +0000, James Dingwall wrote:
> Hi,
> 
> I've been given an account in the bugzilla but on submitting:
> 
> Forbidden
> 
> You don't have permission to access this resource.

This is an issue on the server side, would you please provide some
information privately to debug it?

Thanks.
