From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/3] NETFILTER: New PPTP helper
Date: Sat, 17 Sep 2005 21:05:52 +0200
Message-ID: <432C6910.80905@trash.net>
References: <20050915145406.GC17121@rama.de.gnumonks.org>	<4329F94E.4060107@trash.net>	<20050916091548.GO5034@sunbeam.de.gnumonks.org>	<20050916.154556.116608678.davem@davemloft.net>	<20050916225131.GS8413@sunbeam.de.gnumonks.org>	<432C443C.5010101@trash.net>
	<20050917183321.GF8413@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	"David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050917183321.GF8413@sunbeam.de.gnumonks.org>
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

Harald Welte wrote:
> On Sat, Sep 17, 2005 at 06:28:44PM +0200, Patrick McHardy wrote:
>
>>Anyway, I was just writing a mail including some more suggestions when
>>Dave applied the patch. I'll go over the patch again later and send
>>you my remaining suggestions.
> 
> Ok, in case you're interested in the latest code (confirmed to work in
> my testcases) including all 8 of your patches, please check my
> netfilter-2.6.14 tree (loacal "pptp" branch) on people.netfilter.org.

I tried cloning it using cogito, but get this error:

kaber@krusty:~/src/nf$ cg-clone 
http://people.netfilter.org./laforge/scm/netfilter-2.6.14.git#pptp 
nf-2.6.14-laforge
defaulting to local storage area
warning: templates not found /home/kaber/share/git-core/templates/
20:59:02 
URL:http://people.netfilter.org./laforge/scm/netfilter-2.6.14.git/refs/heads/pptp 
[41/41] -> "refs/heads/origin" [1]
progress: 3 objects, 1452 bytes
Getting pack list
Getting index for pack e3117bbaf6a59cb53c3f6f0d9b17b9433f0e4135
Getting index for pack c60dc6f7486e34043bd6861d6b2c0d21756dde76
error: Couldn't get ca442d313d86dc67e0a2e5d584b465bd382cbf5c: not 
separate or in any pack
error: Tried 
http://people.netfilter.org./laforge/scm/netfilter-2.6.14.git/objects/ca/442d313d86dc67e0a2e5d584b465bd382cbf5c
Cannot obtain needed blob ca442d313d86dc67e0a2e5d584b465bd382cbf5c
while processing commit 4736abe4dcc715c9b20942cf1245623a95fe4370.
cg-pull: objects pull failed
cg-clone: pull failed

I'll try if a new version helps, but it looks like some files are
missing.

> I'll wait for your remaining suggestions and only submit to davem after
> that.

Please see my other mail. I hope I'm not too anoying, but I prefer
to do these minor changes before submission because its often not
worth the time for sending patches afterwards.
