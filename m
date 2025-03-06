Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B10A533C9;
	Thu,  6 Mar 2025 02:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741229225; cv=none; b=n1jYRFWy+cGgCDO7rZYEaqctPul892c4nqTphrsCdyfTdeBRTHQvjUkE2VfveM3948baZsQaSulG3TnCoIE+OmNUX7BbF+QDhJYGkCa+NjhHrXlWO36saOD7Ja+wQer3UWAvBWL6UsOu53dt281xPmQHnU2vbmP7OPzkvpgS5tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741229225; c=relaxed/simple;
	bh=goC+8SQrADneMnT3cLmLQzmGtHV9HG79bSG5rvQRlFM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LSEBfEEkUKo2tL3Wye+pDg1NY/OxIeqTtVp0L7UgC6AkvDxiCo938BpNlpYjZRkGXACy8lDp9it4UIeiUme73/8BWuhsXIQivkazkTYXruE5V078xw4QE92yF7WIR6qs8WwDQ7hvoG3YOtgitdWLZ21LKPjq3h/NJP6QhmfCCek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tq1GA-0006IL-Af; Thu, 06 Mar 2025 03:46:54 +0100
Date: Thu, 6 Mar 2025 03:46:54 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	Michael Menge <michael.menge@zdv.uni-tuebingen.de>,
	netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: nft reset element crashes with error BUG: unhandled op 8
Message-ID: <20250306024654.GA23740@breakpoint.cc>
References: <20250228151158.Horde.S7bxprjzrKb3P7rZjqTDZz_@webmail.uni-tuebingen.de>
 <20250228142507.GA24116@breakpoint.cc>
 <Z8jOkDx8YhIYKi59@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8jOkDx8YhIYKi59@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >  	case CMD_GET:
> > +	case CMD_RESET:
> >  		break;
> >  	default:
> >  		BUG("unhandled op %d\n", ctx->cmd->op);
> 
> Patch looks good, would you please merge this upstream?

I found more issues while creating a test case for this,
patch will come with additional fixes and tests later today.
