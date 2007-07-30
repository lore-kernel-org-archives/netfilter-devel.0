From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Bugzilla broken?
Date: Mon, 30 Jul 2007 15:35:19 +0200
Message-ID: <46ADE917.5050001@netfilter.org>
References: <1185704830.23716.15.camel@henriknordstrom.net>	
	<46AC82AB.70201@treenet.co.nz> <46ACA229.6090907@netfilter.org>
	<1185739660.23716.32.camel@henriknordstrom.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Cc: Amos Jeffries <squid3@treenet.co.nz>,
	Netfilter Developers <netfilter-devel@lists.netfilter.org>,
	webmaster@netfilter.org
To: Henrik Nordstrom <henrik@henriknordstrom.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <1185739660.23716.32.camel@henriknordstrom.net>
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

Henrik Nordstrom wrote:
> On sön, 2007-07-29 at 16:20 +0200, Pablo Neira Ayuso wrote:
>> Amos Jeffries wrote:
>>> Been that way for a while now... Says very similar things on bug search
>> Yes, it's still broken. We have screw up something during the upgrade
>> and we have to roll back to a previous database backup. I'm sorry for
>> this continued breakage.
> 
> Have you run the checksetup.pl script after the upgrade?

Yes, it complains about a problem in the database. I've been talking to 
some bugzilla guys at #mozdevtools and they told me roll back to a 
recent mysql backup.
