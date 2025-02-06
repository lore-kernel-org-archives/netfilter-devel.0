Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A0E22540F
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Feb 2025 11:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738840239; cv=none; b=eCaHs5KmfGPX6iK2hDIHiYSSvMjpC8nThRlP4QR5zuT1rzaW39LRcvJ1SqLtqCSAdo2aCx7gGWlb1Cf3EqXGUi2Bj4x43i2gfJTSKNTgqbtsK/bS1o8AOJAmZj1ILytOxaytGVifCeWT1smbjb7DCkAt9BTDcZQqGtUCHyZBfss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738840239; c=relaxed/simple;
	bh=ywJxgYTURxUvUZq4rrwDP+f/F4KCN5asFVCM1+z2YwM=;
	h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:To; b=dR66pJUuIWvgniGePwIGHt4+ErCuWvxQpPAaKBxIv975H+NavIktb7MPJAevqktz1LvSZBabO2eAp53aTeJI5ZoKWiCdmdRIAmBKTMRDTmTtK4fxC2Kf21mODmJh5PdnltT4DENUnBZUTvZcIWUndOIR0wUSThDa/wesx/qRl1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fCcJFUu8; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fCcJFUu8"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5401bd6cdb7so851391e87.2
        for <netfilter-devel@vger.kernel.org>; Thu, 06 Feb 2025 03:10:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738840235; x=1739445035; darn=vger.kernel.org;
        h=to:date:message-id:subject:mime-version:content-transfer-encoding
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=XWBRX/qfW9yyWSMKhPVCdlzEEKXVavMh8qLtcT6yNaQ=;
        b=fCcJFUu8nvkLhQPzf3KS61DaunYOpetSnA254HNTcSI6ekX8MEOFRxA0dCSYx2MnQS
         iHO6hd6x3tfsDTTEEFqJJITPqk+s6XloyiNiosqjiW8pM/yPQljh5xZQG56Zxol9t9OC
         qnnpUsKcCEwheKyJrJZJbFjlv+pVcp3Y/j7W2D4mTu2Dmc8VO5FwFL1yz8x/91AqDIQ3
         ShRoPevLS/S01XijTiLexoMCjLW2teZS/r+RF/op3CCstXViHXP+euya6NbKG+byvLsh
         p+jc3IPRreuxnZzkWovVrQixFdkQg1ckiLgSGY9oe4Vu1UqQmSPs4h8sfqCMxXrNx4F2
         exyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738840235; x=1739445035;
        h=to:date:message-id:subject:mime-version:content-transfer-encoding
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XWBRX/qfW9yyWSMKhPVCdlzEEKXVavMh8qLtcT6yNaQ=;
        b=Q5Kis1xzvWtKhQHfiIaAHFGIZLSasWStiHhzDR95xEuNdLplErf89/rDauqRmz8rT0
         RhZEBilPLwjzO2hEnEKUtvKoYuuvuiYy/saRvwmaUX1IgDOD5pVT0GLb+rYeR7d4FEeo
         azlJGeButxtR0TrUmxYSCLXtbVr8YzdLcKUZHo+IwWaRjcG/GovAy6m1xv3IxJqFNxxO
         IaMteakkfcS0AuLVhlUOYo2rF8+nf6hcLwEdxG600YqAFKoonSR+2/nMUR1V62KiPGML
         wwfpc9G2URqSpxc2xRNIEKb52NJWDWmdlAakEj4M7qXfsFOp0azuXSdohAxo0tvWlifp
         ssdQ==
X-Gm-Message-State: AOJu0Yx2pUAi7nxf2mvggCNd5B0CuUG8bkZxzIj/F0y/fVQQdNllWO8v
	dCcPjRSJBcUasakOhl05uanFRISjVqnMYzT7OC0xqkX/UbVF2RxPQGqjuMg7
X-Gm-Gg: ASbGncv2sYEWWCK+mSIS+olqU22n3fgmjiLlHUsU9gjWCAokhaVxhMbdU168MABg9FA
	6E9ETzkwKzr5cp3TCi0iDSzSmxAW2vWhUMEk55cntSdX/ClD6odfwSalw+/O9GED8ROcfKI1YY4
	nmiMVtes5GolAr618APV3nbSBHdIl6lv1pDUq2agNZNTr2Xhv0t+4sGZMUZ23qS5li3vlGrWNiv
	+LEgc6caSumGBSlrnwlCvV/cbEMrJ1HVgNkOHsaBcetcEgojSCGZ0Yfut+5i73U9lrvXhTJ+3MZ
	nXyxB9SeDS2M/IVDeayQ9ZpZ5uTmj3Z5epfb
X-Google-Smtp-Source: AGHT+IFt/hQ2noeT85dIDqiQIuDMy5SnJ/wIAPp2YbeOSORDnVU+qQWnhvy58P3c2KObA46RS504Qg==
X-Received: by 2002:a05:6512:3b86:b0:540:3566:5397 with SMTP id 2adb3069b0e04-54405a181f3mr2160320e87.22.1738840234825;
        Thu, 06 Feb 2025 03:10:34 -0800 (PST)
Received: from smtpclient.apple ([195.16.41.104])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-544105f30a3sm104813e87.183.2025.02.06.03.10.34
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Feb 2025 03:10:34 -0800 (PST)
From: Alexey Kashavkin <akashavkin@gmail.com>
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51\))
Subject: Generated value for filtering from two arguments received from the
 command line
Message-Id: <AA705D8C-131B-4305-81A6-840C38AE6E54@gmail.com>
Date: Thu, 6 Feb 2025 14:10:23 +0300
To: netfilter-devel@vger.kernel.org
X-Mailer: Apple Mail (2.3776.700.51)

Hi,

I am developing on adding the IPSO option IPOPT_SEC (RFC1108[1]) for =
filtering as IP options. I take the same as in ipopt.c as a basis. =
According to the IPSO option fields I will have the following fields in =
the nft - TYPE, LENTH and PROTECTION AUTHORITY FLAGS, but for this I =
planned use existing fields (type, length, value).

The PROTECTION AUTHORITY FLAGS field will be a generated field.

What I mean is, the following command line example adds clarification:

# nft add rule ip ipopt_t ipopt_c ip option sec arg1 NUM arg2 NUM =
counter


In parser_bison.y I added:

ip_hdr_expr     :   IP  ip_hdr_field    close_scope_ip
           {
               $$ =3D payload_expr_alloc(&@$, &proto_ip, $2);
           }
           |   IP  OPTION  ip_option_type ip_option_field  =
close_scope_ip
           {
               $$ =3D ipopt_expr_alloc(&@$, $3, $4);
               if (!$$) {
                   erec_queue(error(&@1, "unknown ip option =
type/field"), state->msgs);
                   YYERROR;
               }
           }
           |   IP  OPTION  ip_option_type close_scope_ip
           {
               $$ =3D ipopt_expr_alloc(&@$, $3, IPOPT_FIELD_TYPE);
               $$->exthdr.flags =3D NFT_EXTHDR_F_PRESENT;
           }
           |   IP  OPTION  IPSO   gen_paf close_scope_ip
           {
               $$ =3D ipopt_expr_alloc(&@$, IPOPT_SEC, =
IPOPT_FIELD_VALUE);
           }
           ;

gen_paf        :   arg1   arg2
           {
               unsigned char paf_field[14] =3D {0, 0, 0, 0, 0, 0, 0, 0, =
0, 0, 0, 0, 0, 0};
               struct paf_args =3D {$1, $2}

		$$ =3D build_paf_val(&paf_args, paf_field);
           }
           ;

arg1           :   /* empty */ { $$ =3D 0; }
           |           ARG1    NUM { $$ =3D $2; }
           ;

arg2           :   /* empty */ { $$ =3D 0; }
           |           ARG2    NUM { $$ =3D $2; }
           ;

I don't know bison very well and may be doing something wrong, but what =
I expect from this code is to have a value in place of gen_paf as if the =
user had entered the following:

# nft add rule ip ipopt_t ipopt_c ip option sec value 12345678 counter

The value 12345678 should be generated from the two values specified for =
gen_paf.


To ipopt.c I added:

static const struct exthdr_desc ipopt_sec =3D {
   .name       =3D =C2=ABsec=C2=BB,
   .type       =3D IPOPT_SEC,
   .templates  =3D {
       [IPOPT_FIELD_TYPE]      =3D PHT("type",   0,   8),
       [IPOPT_FIELD_LENGTH]        =3D PHT("length", 8,   8),
       [IPOPT_FIELD_VALUE]     =3D PHT("value",  24, 14),
   },
};


nft_parse() returned the error:

Error: syntax error, unexpected drop
add rule ip ipopt_t ipopt_c ip option sec arg1 11 arg2 3 drop


I did this because I don't quite understand how I can otherwise generate =
a value for this field before calling ipopt_expr_alloc() and pass it to =
this function. This may not be the right way at all, and if it is, I =
would be very grateful if someone could let me know.

Is there any expression in nft that would also take arguments from the =
command line to generate a value? Having researched the bison code, it =
seems that it should always accept the final value for filtering from =
the command line.

[1] https://www.rfc-editor.org/rfc/rfc1108.html=
