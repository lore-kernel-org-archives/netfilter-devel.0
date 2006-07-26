From: Patrick McHardy <kaber@trash.net>
Subject: Re: external repositories: IPMARK & connlimit
Date: Wed, 26 Jul 2006 15:35:13 +0200
Message-ID: <44C76F91.2060507@trash.net>
References: <Pine.LNX.4.64.0607261415440.5942@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
In-Reply-To: <Pine.LNX.4.64.0607261415440.5942@bizon.gios.gov.pl>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Krzysztof Oledzki wrote:
> Grzegorz Janoszka (author of the IPMARK extension) asked me to take over
> and fix this extension since he currently runs of of time, so I did
> this. :)
> 
> I also fixed the connlimit extension, both are now avaible in my
> external repository hosted on people.netfilter.org, so please remove
> them from pom-ng repository - it is now possible to get both with
> "./runme --download".


Great, thanks. I've removed them and updated the comment in
sources.list.
