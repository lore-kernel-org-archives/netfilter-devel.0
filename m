Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C04F31D555
	for <netfilter-devel@vger.kernel.org>; Tue, 13 May 2025 15:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747151848; cv=none; b=lgQgZX5Nn/jetVvdgsPOk0CHZUpRMmc9eh9T8ynIYIcq/bGR3luG0ugmgFyuDIUTe/Nj9VnAxTgBidS/CRwyIanLp6r7vWx4jF4exXjeae+EcuuwcOQMTVlNrHBM2w/e9bv+gK21o1aVNxOjIPnkBscasf5VtGLn0U5YyRuH40Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747151848; c=relaxed/simple;
	bh=UgAcjhx2yGQ/FSUc9Rw25dAk2mjr0dCNdw86A/YrxJI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rjJQEzWeXMayKtO9fha4OgQn9NpqfOBhQ1Wos09FbaK0gDcmTuVlEJJ9pEqiy92dG7ZgW4uz+fjdHXyfaKqobwU0bQXRDEtKevP2baa8yPsWm4D/uNE8X0dq50qGuy2QhhOmmECygW5O2+32bQcam+ZQ8hVl9VjSrSQUW3ta85A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=AfWVXgEU; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="AfWVXgEU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=DYYxKdIAjnWbaOJiLdKEInixISBb7zkb6Jru4OwMX3o=; b=AfWVXgEUE8tkyJTkS5TMD+Sjay
	bf523D9PRK71MWriEc2kPAfct1EXgo6E5rg7vpvwzTU8O/pT5Dp1GaY1hy3Lh5bzzsTGVw16u04v5
	TS5ZI68bs4n0gh5og+ZJcTDdtRufxtcEW1udd3VQQ5wrBGobriXzStJTS3vXhnKpWq3ug15ya7E1f
	TZLqUxTH72f6EaQ26dMPnQA9i4AynZ8T4lOxS19F1KJjlAACt/lOTQ+e66uf2Sdyju4aEzYzHPkXf
	QpZyZOFPxRpUM6AZlkL2O0J7gWGGQ7rWIRZkYPNUE+HrJHdT8SJJ9A/XyoXoLqqfJhQebMP7lgo9r
	Y+1taWwA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uEs0G-000000001sq-2c7h;
	Tue, 13 May 2025 17:57:12 +0200
Date: Tue, 13 May 2025 17:57:12 +0200
From: Phil Sutter <phil@nwl.cc>
To: =?utf-8?B?5ZGo5oG66Iiq?= <22321077@zju.edu.cn>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: Re: Fix resource leak in iptables/xtables-restore.c
Message-ID: <aCNr2GS7Pyp6wsJH@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	=?utf-8?B?5ZGo5oG66Iiq?= <22321077@zju.edu.cn>,
	netfilter-devel@vger.kernel.org
References: <87aa5c8.77e3.196c354f80c.Coremail.22321077@zju.edu.cn>
 <aCHMICSGU2LT7SS-@orbyte.nwl.cc>
 <63b7ba31.88a5.196c815f8b5.Coremail.22321077@zju.edu.cn>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <63b7ba31.88a5.196c815f8b5.Coremail.22321077@zju.edu.cn>

On Tue, May 13, 2025 at 01:20:05PM +0800, 周恺航 wrote:
> 
> 
> 
> > -----Original Message-----
> 
> 
> > From: "Phil Sutter" <phil@nwl.cc>
> 
> > Sent: Monday, May 12, 2025 18:23:28
> > To: 周恺航 <22321077@zju.edu.cn>
> > Cc: netfilter-devel@vger.kernel.org
> > Subject: Re: Fix resource leak in iptables/xtables-restore.cc
> > 
> > Hi,
> > 
> > On Mon, May 12, 2025 at 03:10:47PM +0800, 周恺航 wrote:
> > > The function xtables_restore_main opens a file stream p.in but fails to close it before returning. This leads to a resource leak as the file descriptor remains open.
> > > 
> > > 
> > > Signed-off-by: Kaihang Zhou <22321077@zju.edu.cn>
> > > 
> > > ---
> > >  iptables/xtables-restore.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > > 
> > > 
> > > diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
> > > 
> > > index e7802b9e..f09ab7ee 100644
> > > --- a/iptables/xtables-restore.c
> > > +++ b/iptables/xtables-restore.c
> > > @@ -381,6 +381,7 @@ xtables_restore_main(int family, const char *progname, int argc, char *argv[])
> > >                 break;
> > >         default:
> > >                 fprintf(stderr, "Unknown family %d\n", family);
> > > +               fclose(p.in);
> > >                 return 1;
> > >         }
> > 
> > Since this is not the only error path which leaves p.in open (eight
> > lines below is the next one for instance), why fix this one in
> > particular and leave the other ones in place?
> > 
> > Cheers, Phil
> 
> At first, I thought that not closing the file handle before the return was more serious, and that when exit terminates the program, the system might automatically reclaim resources. But it's obvious that this understanding is wrong. Both are bad programming habits and may lead to problems in resource management and program stability. I've revised the patch.Thank you.

I was not listing all problematic cases but merely giving an example.
Another one is the exit() call in xtables_restore_parse() or all calls
to xtables_error() in various spots. If you want to avoid p.in remaining
open upon program exit in error paths, please submit a patch which
addresses all cases.

Thanks, Phil
