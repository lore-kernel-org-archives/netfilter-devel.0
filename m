From: Florian Westphal <fw@strlen.de>
Subject: Re: [nft] add default branch for code integrality
Date: Thu, 26 Nov 2015 11:34:12 +0100
Message-ID: <20151126103412.GA22027@breakpoint.cc>
References: <0A900C78B9F2324AB7F4F7A51D1A2F8577978285@szxema505-mbs.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "pablo@netfilter.org" <pablo@netfilter.org>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Linmujia <linmujia@huawei.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:36354 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751014AbbKZKeS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Nov 2015 05:34:18 -0500
Content-Disposition: inline
In-Reply-To: <0A900C78B9F2324AB7F4F7A51D1A2F8577978285@szxema505-mbs.china.huawei.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Linmujia <linmujia@huawei.com> wrote:
> @@ -1778,14 +1784,17 @@ static int netlink_events_chain_cb(const struct nlmsghdr *nlh, int type,
>  			       nftnl_chain_get_str(nlc,
>  						      NFTNL_CHAIN_NAME));
>  			break;
> +		default:
> +			break;
>  		}
> -		break;
>  	case NFTNL_OUTPUT_XML:

That looks bogus.  We would now fallthough to XML label?

Did you test this...?
