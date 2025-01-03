Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 870931FC11D
	for <netfilter-devel@vger.kernel.org>; Fri,  3 Jan 2025 17:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735925994; cv=none; b=pyURd04xVz+5rqSCaeP6v8VkRoE+WKKNUYNbTo/251Get55Lb1hmahie2IRzQwZMiHZ95sX/z8N03OpTaEfZSjtv7tyKT1wRwTuSB8Tu0/bBjdEEiy1Fs2/kqPntfExsPAD+Y65hEHJxKvk2GauemM8MvdsaWpFZj2K6J6RHcKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735925994; c=relaxed/simple;
	bh=cYiBEg22nw6sjbxRaOEPGiPwpBvRyyPhOT/Z6MtWw3s=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e8iZ9njfbx4kP3PlbpI1fOyQv4xvdS/GsTvxnp9wUEqDLHZFfbIMkUvhZ87ik+E3BwS0ZmMU+k6cJTbpa1NOgBKBfw7G3yw/EAVSNSGs8WnaKI/pD9JsyfsI0EQ+k99diutheztYrdzzFDDLVpbcAXYeh/hMBOeEbmiPTXNUZa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
X-Spam-Level: 
Date: Fri, 3 Jan 2025 18:39:48 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_tables: imbalance in flowtable binding
Message-ID: <Z3gg5N3j1Rge8pdb@calendula>
References: <20250102154443.2252675-1-pablo@netfilter.org>
 <Z3ggQ_KxCOBPfsPa@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z3ggQ_KxCOBPfsPa@orbyte.nwl.cc>

On Fri, Jan 03, 2025 at 06:37:07PM +0100, Phil Sutter wrote:
> Hi Pablo,
> 
> On Thu, Jan 02, 2025 at 04:44:43PM +0100, Pablo Neira Ayuso wrote:
> > All these cases cause imbalance between BIND and UNBIND calls:
> > 
> > - Delete an interface from a flowtable with multiple interfaces
> > 
> > - Add a (device to a) flowtable with --check flag
> > 
> > - Delete a netns containing a flowtable
> > 
> > - In an interactive nft session, create a table with owner flag and
> >   flowtable inside, then quit.
> > 
> > Fix it by calling FLOW_BLOCK_UNBIND when unregistering hooks, then
> > remove late FLOW_BLOCK_UNBIND call when destroying flowtable.
> > 
> > Fixes: ff4bf2f42a40 ("netfilter: nf_tables: add nft_unregister_flowtable_hook()")
> > Reported-by: Phil Sutter <phil@nwl.cc>
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> Tested-by: Phil Sutter <phil@nwl.cc>
> 
> Added printk calls for debugging and recreated the above scenarios, no
> imbalance found. Thanks for your fix!

Thanks for testing.

> I have to rebase my pending patch series upon this one now. :)

Please go ahead, thanks Phil.
