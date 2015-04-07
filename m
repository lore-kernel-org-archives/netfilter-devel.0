From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH 1/9] netfilter: Create and use nf_hook_state.
Date: Tue, 7 Apr 2015 14:27:22 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1CB15A10@AcuExch.aculab.com>
References: <20150403.220743.1982329121589716666.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"pablo@netfilter.org" <pablo@netfilter.org>,
	"hannes@stressinduktion.org" <hannes@stressinduktion.org>,
	"jiri@resnulli.us" <jiri@resnulli.us>
To: 'David Miller' <davem@davemloft.net>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20150403.220743.1982329121589716666.davem@davemloft.net>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

> Instead of passing a large number of arguments down into the nf_hook()
> entry points, create a structure which carries this state down through
> the hook processing layers.
> 
> This makes is so that if we want to change the types or signatures of
> any of these pieces of state, there are less places that need to be
> changed.

Should the structure be passed as a 'const foo *' ?
Or is that always too restrictive?

	David
