From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] ipset: fix syntax error in bash completion and hyphen
 used as minus sign in manpage
Date: Sat, 11 May 2013 23:05:08 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1305112301160.29805@blackhole.kfki.hu>
References: <20130511013452.GA31273@nitrogen.neutroncom.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org,
	Born Without <blackhole@airpost.net>
To: Neutron Soutmun <neo.neutron@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:35118 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754217Ab3EKVFK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 11 May 2013 17:05:10 -0400
In-Reply-To: <20130511013452.GA31273@nitrogen.neutroncom.local>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Sat, 11 May 2013, Neutron Soutmun wrote:

> I have prepared the Debian package for new 6.19 release,
> The Lintian (Debian packaging tool) has warned about the syntax error in
> ipset bash completion script and also the hyphen used as minus sign in
> manpage.

Could you send the two things separated into two patches: one for the 
manpage and one for the bash completion tool? The latter must be updated 
at its source first at github (author is Cc-d).

Best regards,
Jozsef 
> The syntax error is shown as below.
> 
> $ bash ipset_bash_completion
> ipset_bash_completion: line 680: syntax error near unexpected token `('                                                                     
> ipset_bash_completion: line 680: `
> @(create|n|add|del|test|destroy|x|list|save|restore|flush|rename|e|swap|w|help|version))'
> 
> Therefore, the patches was included in debian package and push to github
> which prepared for the pull-request.
> 
> Please consider to merge them.
> 
> Best regards,
> Neutron Soutmun
> 
> 
> The following changes since commit 85196765617c27d69155618d113addbc418679ad:
> 
>   ipset 6.19 released (2013-05-09 17:33:39 +0200)
> 
> are available in the git repository at:
> 
>   git://github.com/neutronth/ipset.git debian-fix
> 
> for you to fetch changes up to 77124447af920585d53dd3e28e2a41e5418f1d3d:
> 
>   Fix hyphen used as minus sign in manpage (2013-05-11 07:58:22 +0700)
> 
> ----------------------------------------------------------------
> Neutron Soutmun (2):
>       Set extglob shell option in global scoped
>       Fix hyphen used as minus sign in manpage
> 
>  src/ipset.8                                       |    2 +-
>  utils/ipset_bash_completion/ipset_bash_completion |    3 ++-
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/src/ipset.8 b/src/ipset.8
> index 6e627a2..7bb55e1 100644
> --- a/src/ipset.8
> +++ b/src/ipset.8
> @@ -278,7 +278,7 @@ ipset create test hash:ip timeout 300
>  .IP
>  ipset add test 192.168.0.1 timeout 60
>  .IP
> -ipset -exist add test 192.168.0.1 timeout 600
> +ipset \-exist add test 192.168.0.1 timeout 600
>  .PP 
>  .SS nomatch
>  The \fBhash\fR set types which can store \fBnet\fR type of data (i.e. hash:*net*)
> diff --git a/utils/ipset_bash_completion/ipset_bash_completion b/utils/ipset_bash_completion/ipset_bash_completion
> index cc7ea7b..69ba635 100644
> --- a/utils/ipset_bash_completion/ipset_bash_completion
> +++ b/utils/ipset_bash_completion/ipset_bash_completion
> @@ -47,6 +47,8 @@
>  #
>  # -----------------------------------------------------------------
>  
> +shopt -s extglob
> +
>  # -----------------------------------------------------------------
>  # Functions
>  # -----------------------------------------------------------------
> @@ -537,7 +539,6 @@ done < "${_IPSET_IPLIST_FILE}"
>  # -----------------------------------------------------------------
>  
>  _ipset_complete() {
> -shopt -s extglob
>  local cur prev cword words ips_version
>  local str_action str_setname str_type str_filename
>  local str_glob str_regex str_prefix str_suffix
> 

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
