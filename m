From: Amos Jeffries <squid3@treenet.co.nz>
Subject: Re: Bugzilla broken?
Date: Mon, 30 Jul 2007 00:06:03 +1200
Message-ID: <46AC82AB.70201@treenet.co.nz>
References: <1185704830.23716.15.camel@henriknordstrom.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>,
	webmaster@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <1185704830.23716.15.camel@henriknordstrom.net>
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
> Stumbled across bug, and tried to register an bugzilla account to get it
> properly filed.. but failed...
> 
> On the first login:
> Software error:
> DBD::mysql::st execute failed: Unknown column 'grant_type' in 'where clause' [for Statement "SELECT groups.name, groups.id
>                             FROM group_group_map
>                       INNER JOIN groups
>                               ON groups.id = grantor_id
>                            WHERE member_id = ? 
>                              AND grant_type = 0" with ParamValues: 0='6'] at Bugzilla/User.pm line 290
> 	Bugzilla::User::groups('Bugzilla::User=HASH(0x111afcc0)') called at Bugzilla/User.pm line 361
> 	Bugzilla::User::in_group('Bugzilla::User=HASH(0x111afcc0)', 'bz_sudoers') called at Bugzilla.pm line 176
> 	Bugzilla::login('Bugzilla', 0) called at /var/www/bugzilla.netfilter.org/htdocs/bugzilla/index.cgi line 37
> 
> For help, please send mail to the webmaster (webmaster@netfilter.org),
> giving this error message and the time and date of the error.
> 
> Regards
> Henrik
> 
> 

Been that way for a while now... Says very similar things on bug search too:

Software error:

DBD::mysql::st execute failed: Unknown column 
'products.classification_id' in 'where clause' [for Statement "SELECT 
products.name, classifications.name FROM products, classifications WHERE 
classifications.id = products.classification_id ORDER BY 
classifications.name"] at Bugzilla/DB.pm line 84
	Bugzilla::DB::SendSQL('SELECT products.name, classifications.name FROM 
products, cla...') called at globals.pl line 140
	main::GenerateVersionTable() called at globals.pl line 312
	main::GetVersionTable() called at Bugzilla/Search/Quicksearch.pm line 146
	Bugzilla::Search::Quicksearch::quicksearch('ORIGINAL_DST') called at 
/var/www/bugzilla.netfilter.org/htdocs/bugzilla/buglist.cgi line 76



Hi Henrik.

Amos
