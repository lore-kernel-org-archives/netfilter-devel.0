From: Edward Cree <ecree@solarflare.com>
Subject: Re: [PATCH net-next,RFC 00/13] New fast forwarding path
Date: Fri, 15 Jun 2018 13:18:57 +0100
Message-ID: <06736a3f-428b-3a12-e7c7-eeeb2596a8a3@solarflare.com>
References: <20180614141947.3580-1-pablo@netfilter.org>
 <CALx6S345B2-sejH52beewdiHuGo5nAY0v0uFmNuiJ0hQ6Wu3xw@mail.gmail.com>
 <20180614.165834.338565136334574983.davem@davemloft.net>
 <20180615063433.g4pqrea4f4pymvvs@gauss3.secunet.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: <tom@herbertland.com>, <pablo@netfilter.org>,
        <netfilter-devel@vger.kernel.org>, <netdev@vger.kernel.org>
To: Steffen Klassert <steffen.klassert@secunet.com>,
        David Miller <davem@davemloft.net>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180615063433.g4pqrea4f4pymvvs@gauss3.secunet.de>
Content-Language: en-GB
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 15/06/18 07:34, Steffen Klassert wrote:
> On Thu, Jun 14, 2018 at 04:58:34PM -0700, David Miller wrote:
>> You're probably talking about Edward Cree's SKB list stuff, and as
>> per his presenation at netconf 2 weeks ago he plans to revitalize
>> it given how Spectre et al. gives cause to reevaluate all bulking
>> techniques.
> Are there patches for the proposal Edward did a while ago,
> or was it just a concept?
Old patches are at http://lists.openwall.net/netdev/2016/04/19/89
 (note that the absolute numbers I give in the cover letter are wrong;
 I quoted them as Mpps but they're actually Mbps which is 8x higher).
I hope to have a new series ready shortly after net-next reopens.

-Ed
