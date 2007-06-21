From: "Jay Manni" <JManni@FireEye.com>
Subject: Error accessing netfilter bugzilla
Date: Thu, 21 Jun 2007 10:27:09 -0700
Message-ID: <74ECB30468A30A4DA2BD88DA5387CAE366D2E8@fempexch.FireEye.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="windows-1250"
Content-Transfer-Encoding: quoted-printable
To: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
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

Trying to access =
https://bugzilla.netfilter.org/bugzilla/show_bug.cgi?id=3D467 linked =
from http://bugzilla.kernel.org/show_bug.cgi?id=3D6420


Software error:
DBD::mysql::st execute failed: Unknown column =
'products.classification_id' in 'where clause' [for Statement "SELECT =
products.name, classifications.name FROM products, classifications WHERE =
classifications.id =3D products.classification_id ORDER BY =
classifications.name"] at Bugzilla/DB.pm line 84
	Bugzilla::DB::SendSQL('SELECT products.name, classifications.name FROM =
products, cla...') called at globals.pl line 140
	main::GenerateVersionTable() called at globals.pl line 312
	main::GetVersionTable() called at =
/var/www/bugzilla.netfilter.org/htdocs/bugzilla/show_bug.cgi line 60
For help, please send mail to the webmaster (webmaster@netfilter.org), =
giving this error message and the time and date of the error.=20


No virus found in this outgoing message.
Checked by AVG Free Edition.=20
Version: 7.5.472 / Virus Database: 269.9.2/858 - Release Date: 6/21/2007 =
1:46 PM
=20
