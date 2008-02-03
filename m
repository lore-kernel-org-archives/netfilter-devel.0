From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 01/34]  Introduce new SQL schema.
Date: Sun, 03 Feb 2008 12:22:57 +0100
Message-ID: <47A5A411.9040307@netfilter.org>
References: <1201987469575-git-send-email-eric@inl.fr> <1201987469368-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33767 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753799AbYBCLXV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Feb 2008 06:23:21 -0500
In-Reply-To: <1201987469368-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Applied. Thanks. BTW, one question:

Eric Leblond wrote
> @@ -88,25 +90,8 @@ static int sql_createstmt(struct ulogd_pluginstance *upi)
>  		return -ENOMEM;
>  	}
>  
> -	if (mi->schema)
> -		sprintf(mi->stmt, "insert into %s.%s (", mi->schema, table);
> -	else
> -		sprintf(mi->stmt, "insert into %s (", table);
> -	mi->stmt_val = mi->stmt + strlen(mi->stmt);
> -
> -	for (i = 0; i < upi->input.num_keys; i++) {
> -		if (upi->input.keys[i].flags & ULOGD_KEYF_INACTIVE)
> -			continue;
> -
> -		strncpy(buf, upi->input.keys[i].name, ULOGD_MAX_KEYLEN);	
> -		while ((underscore = strchr(buf, '.')))
> -			*underscore = '_';
> -		sprintf(mi->stmt_val, "%s,", buf);
> -		mi->stmt_val = mi->stmt + strlen(mi->stmt);
> -	}
> -	*(mi->stmt_val - 1) = ')';
> +	sprintf(mi->stmt, "CALL %s(", procedure);
>  
> -	sprintf(mi->stmt_val, " values (");
>  	mi->stmt_val = mi->stmt + strlen(mi->stmt);
>  
>  	ulogd_log(ULOGD_DEBUG, "stmt='%s'\n", mi->stmt);

Since now we use user-defined procedures and call them, we have to
remove the old mysql and pgsql definitions from doc/ as well which does
not use it, and what about sqlite3?

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
