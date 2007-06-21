From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Error accessing netfilter bugzilla
Date: Thu, 21 Jun 2007 19:48:34 +0200
Message-ID: <467AB9F2.2040508@netfilter.org>
References: <74ECB30468A30A4DA2BD88DA5387CAE366D2E8@fempexch.FireEye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1250
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Jay Manni <JManni@FireEye.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <74ECB30468A30A4DA2BD88DA5387CAE366D2E8@fempexch.FireEye.com>
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

Jay Manni wrote:
> Trying to access https://bugzilla.netfilter.org/bugzilla/show_bug.cgi?id=467 linked from http://bugzilla.kernel.org/show_bug.cgi?id=6420
> 
> Software error:
> DBD::mysql::st execute failed: Unknown column 'products.classification_id' in 'where clause' [for Statement "SELECT products.name, classifications.name FROM products, classifications WHERE classifications.id = products.classification_id ORDER BY classifications.name"] at Bugzilla/DB.pm line 84
> 	Bugzilla::DB::SendSQL('SELECT products.name, classifications.name FROM products, cla...') called at globals.pl line 140
> 	main::GenerateVersionTable() called at globals.pl line 312
> 	main::GetVersionTable() called at /var/www/bugzilla.netfilter.org/htdocs/bugzilla/show_bug.cgi line 60
> For help, please send mail to the webmaster (webmaster@netfilter.org), giving this error message and the time and date of the error. 

I'll investigate this. Thanks for the report.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
