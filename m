From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: bug: -j REDIRECT broken with bridge in 2.6.0-test3
Date: Tue, 26 Aug 2003 08:12:08 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200308260812.08884.bdschuym@pandora.be>
References: <3F3AEDEF.2000108@metavize.com> <3F4A9AA7.2070604@metavize.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: dmorris <dmorris@metavize.com>,
	netfilter-devel@lists.netfilter.org
In-Reply-To: <3F4A9AA7.2070604@metavize.com>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tuesday 26 August 2003 01:24, dmorris wrote:
> Does anyone have *any* idea where I could look to start solving this?
> Can anyone confirm?
> It is still present in 2.6.0-test4 on my test machines.

I think this should be fixed with the patch Harald sent to Dave, see the 
thread "Fix ipt_REJECT if used on bridge". I don't see it in Linus' tree yet.

cheers,
Bart
